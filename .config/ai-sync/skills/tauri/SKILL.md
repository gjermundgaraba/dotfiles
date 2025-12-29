---
name: tauri
description: Build desktop and mobile apps with Tauri v2, a Rust-based framework using web frontends (HTML/CSS/JS). Use when creating new Tauri projects, adding Rust commands, configuring IPC between frontend and backend, managing plugins, or building/distributing apps. Triggers for file patterns like src-tauri/*, tauri.conf.json, or questions about Tauri commands, events, capabilities, or plugins.
---

# Tauri v2

Build tiny, fast desktop/mobile apps with any web frontend and Rust backend.

## Quick Start

### New Project

```bash
npm create tauri-app@latest
cd my-app && npm install && npm run tauri dev
```

### Add to Existing Frontend

```bash
npm install -D @tauri-apps/cli
npx tauri init
npx tauri dev
```

## Project Structure

```
my-app/
├── src/                    # Frontend code
├── src-tauri/
│   ├── Cargo.toml         # Rust dependencies
│   ├── tauri.conf.json    # Tauri config
│   ├── capabilities/      # Permission definitions
│   │   └── default.json
│   ├── src/
│   │   └── lib.rs         # Rust commands
│   └── icons/
└── package.json
```

## Core Workflow

### 1. Define Rust Commands

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
        .expect("error running app");
}
```

### 2. Call from Frontend

```typescript
import { invoke } from '@tauri-apps/api/core';

const result = await invoke('greet', { name: 'World' });
```

### 3. Add Plugins

```bash
npx tauri add dialog
npx tauri add fs
npx tauri add shell
```

### 4. Configure Capabilities

```json
// src-tauri/capabilities/default.json
{
  "identifier": "default",
  "windows": ["main"],
  "permissions": [
    "core:default",
    "dialog:allow-open",
    "fs:default"
  ]
}
```

### 5. Build

```bash
npx tauri build                    # All formats
npx tauri build --bundles dmg      # macOS DMG
npx tauri build --bundles msi      # Windows MSI
npx tauri build --bundles appimage # Linux AppImage
```

## State Management

```rust
use std::sync::Mutex;
use tauri::State;

struct AppState { counter: u32 }

#[tauri::command]
fn increment(state: State<'_, Mutex<AppState>>) -> u32 {
    let mut s = state.lock().unwrap();
    s.counter += 1;
    s.counter
}

// In run():
.setup(|app| {
    app.manage(Mutex::new(AppState { counter: 0 }));
    Ok(())
})
```

## Error Handling

```rust
#[derive(Debug, thiserror::Error)]
enum Error {
    #[error(transparent)]
    Io(#[from] std::io::Error),
}

impl serde::Serialize for Error {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where S: serde::ser::Serializer {
        serializer.serialize_str(self.to_string().as_ref())
    }
}

#[tauri::command]
fn read_file(path: String) -> Result<String, Error> {
    Ok(std::fs::read_to_string(path)?)
}
```

## Essential Config

```json
// src-tauri/tauri.conf.json
{
  "productName": "My App",
  "identifier": "com.company.myapp",
  "version": "1.0.0",
  "build": {
    "devUrl": "http://localhost:5173",
    "frontendDist": "../dist"
  },
  "app": {
    "windows": [{
      "title": "My App",
      "width": 800,
      "height": 600
    }]
  }
}
```

## Mobile Development

```bash
# Android
npx tauri android init
npx tauri android dev

# iOS (macOS only)
npx tauri ios init
npx tauri ios dev
```

## References

- **[commands.md](references/commands.md)**: Complete IPC patterns, async commands, events, channels
- **[config.md](references/config.md)**: Full configuration reference, window options, security settings
- **[plugins.md](references/plugins.md)**: Official plugins usage (dialog, fs, shell, http, sql, etc.)
- **[cli.md](references/cli.md)**: All CLI commands and options
