# Tauri Commands & IPC

## Table of Contents
- [Commands](#commands)
- [Passing Arguments](#passing-arguments)
- [Return Values](#return-values)
- [Error Handling](#error-handling)
- [Async Commands](#async-commands)
- [Accessing Context](#accessing-context)
- [Channels](#channels)
- [Events](#events)

## Commands

Commands are Rust functions decorated with `#[tauri::command]` that can be invoked from JavaScript.

### Basic Command

```rust
// src-tauri/src/lib.rs
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![greet])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
```

### Frontend Invocation

```typescript
import { invoke } from '@tauri-apps/api/core';

// Call command
const greeting = await invoke('greet', { name: 'World' });
console.log(greeting); // "Hello, World!"
```

## Passing Arguments

Arguments are deserialized from JSON. Frontend uses camelCase, Rust receives as named params:

```rust
#[tauri::command]
fn login(user: String, password: String) -> Result<String, String> {
    if user == "admin" && password == "secret" {
        Ok("logged_in".to_string())
    } else {
        Err("invalid credentials".to_string())
    }
}
```

```typescript
invoke('login', { user: 'admin', password: 'secret' })
    .then(msg => console.log(msg))
    .catch(err => console.error(err));
```

## Return Values

Commands return data serialized as JSON. For binary data, use `Response`:

```rust
use tauri::ipc::Response;

#[tauri::command]
fn read_file(path: String) -> Response {
    let data = std::fs::read(&path).unwrap();
    Response::new(data)
}
```

## Error Handling

Return `Result` types with serializable errors. Use `thiserror`:

```rust
#[derive(Debug, thiserror::Error)]
enum Error {
    #[error(transparent)]
    Io(#[from] std::io::Error),
    #[error("invalid input: {0}")]
    InvalidInput(String),
}

impl serde::Serialize for Error {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where S: serde::ser::Serializer {
        serializer.serialize_str(self.to_string().as_ref())
    }
}

#[tauri::command]
fn read_data(path: String) -> Result<String, Error> {
    let content = std::fs::read_to_string(&path)?;
    Ok(content)
}
```

## Async Commands

Async commands prevent UI blocking:

```rust
#[tauri::command]
async fn fetch_data(url: String) -> Result<String, String> {
    // Async operations here
    let response = reqwest::get(&url).await.map_err(|e| e.to_string())?;
    response.text().await.map_err(|e| e.to_string())
}
```

**Note**: Async commands cannot use borrowed types like `&str`; use `String` instead.

## Accessing Context

Commands can access app context:

```rust
use tauri::State;
use std::sync::Mutex;

struct AppState {
    counter: u32,
}

#[tauri::command]
fn increment(state: State<'_, Mutex<AppState>>) -> u32 {
    let mut state = state.lock().unwrap();
    state.counter += 1;
    state.counter
}

#[tauri::command]
fn get_window_label(window: tauri::WebviewWindow) -> String {
    window.label().to_string()
}

#[tauri::command]
async fn do_something(app: tauri::AppHandle) -> Result<(), String> {
    // Access app resources
    Ok(())
}
```

## Channels

Stream data using channels:

```rust
#[tauri::command]
async fn stream_file(
    path: std::path::PathBuf,
    channel: tauri::ipc::Channel<Vec<u8>>,
) -> Result<(), String> {
    use tokio::io::AsyncReadExt;
    let mut file = tokio::fs::File::open(&path).await.map_err(|e| e.to_string())?;
    let mut buffer = vec![0u8; 4096];
    loop {
        let n = file.read(&mut buffer).await.map_err(|e| e.to_string())?;
        if n == 0 { break; }
        channel.send(buffer[..n].to_vec()).map_err(|e| e.to_string())?;
    }
    Ok(())
}
```

```typescript
import { invoke, Channel } from '@tauri-apps/api/core';

const channel = new Channel<Uint8Array>();
channel.onmessage = (chunk) => {
    console.log('Received chunk:', chunk.length);
};
await invoke('stream_file', { path: '/path/to/file', channel });
```

## Events

Events provide async communication without return values.

### Emit from Frontend

```typescript
import { emit, emitTo } from '@tauri-apps/api/event';

// Emit to all listeners
emit('file-selected', { path: '/path/to/file' });

// Emit to specific webview
emitTo('settings', 'update-config', { theme: 'dark' });
```

### Listen in Frontend

```typescript
import { listen, once } from '@tauri-apps/api/event';

const unlisten = await listen('download-progress', (event) => {
    console.log('Progress:', event.payload);
});

// Listen only once
await once('app-ready', (event) => {
    console.log('App is ready');
});
```

### Listen in Rust

```rust
use tauri::Listener;

fn setup(app: &mut tauri::App) -> Result<(), Box<dyn std::error::Error>> {
    app.listen("file-selected", |event| {
        println!("File selected: {}", event.payload());
    });
    Ok(())
}
```

### Emit from Rust

```rust
use tauri::Emitter;

#[tauri::command]
fn start_download(app: tauri::AppHandle) {
    std::thread::spawn(move || {
        for i in 0..100 {
            app.emit("download-progress", i).unwrap();
            std::thread::sleep(std::time::Duration::from_millis(50));
        }
    });
}
```
