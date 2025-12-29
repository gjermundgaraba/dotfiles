# Tauri Plugins Reference

## Table of Contents
- [Installing Plugins](#installing-plugins)
- [Desktop Plugins](#desktop-plugins)
- [Mobile Plugins](#mobile-plugins)
- [Networking Plugins](#networking-plugins)
- [Storage Plugins](#storage-plugins)
- [Security Plugins](#security-plugins)

## Installing Plugins

```bash
# Add plugin to project
npx tauri add <plugin-name>

# Or manually:
# 1. Add to Cargo.toml
# 2. Register in lib.rs
# 3. Add JS package if needed
```

### Manual Installation Example

```toml
# src-tauri/Cargo.toml
[dependencies]
tauri-plugin-shell = "2"
```

```rust
// src-tauri/src/lib.rs
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_shell::init())
        .run(tauri::generate_context!())
        .expect("error running app");
}
```

```bash
npm install @tauri-apps/plugin-shell
```

## Desktop Plugins

### Shell

Execute commands and open URLs:

```typescript
import { open } from '@tauri-apps/plugin-shell';
import { Command } from '@tauri-apps/plugin-shell';

// Open URL in browser
await open('https://tauri.app');

// Run command
const output = await Command.create('git', ['status']).execute();
console.log(output.stdout);
```

### Dialog

File and message dialogs:

```typescript
import { open, save, message, ask, confirm } from '@tauri-apps/plugin-dialog';

// File picker
const files = await open({
    multiple: true,
    filters: [{ name: 'Images', extensions: ['png', 'jpg'] }]
});

// Save dialog
const path = await save({
    defaultPath: 'document.txt'
});

// Message box
await message('Operation complete', { title: 'Success', kind: 'info' });

// Confirmation
const confirmed = await confirm('Delete this file?', { title: 'Confirm' });
```

### Clipboard

```typescript
import { writeText, readText } from '@tauri-apps/plugin-clipboard-manager';

await writeText('Hello clipboard');
const text = await readText();
```

### Notifications

```typescript
import { sendNotification, isPermissionGranted, requestPermission } from '@tauri-apps/plugin-notification';

if (!(await isPermissionGranted())) {
    await requestPermission();
}

sendNotification({ title: 'Tauri', body: 'Hello from Tauri!' });
```

### Global Shortcut

```typescript
import { register, unregister } from '@tauri-apps/plugin-global-shortcut';

await register('CommandOrControl+Shift+C', () => {
    console.log('Shortcut triggered');
});

await unregister('CommandOrControl+Shift+C');
```

### Autostart

```typescript
import { enable, disable, isEnabled } from '@tauri-apps/plugin-autostart';

await enable();
console.log('Autostart enabled:', await isEnabled());
await disable();
```

### Window State

Persists window position/size automatically. Just add the plugin:

```rust
tauri::Builder::default()
    .plugin(tauri_plugin_window_state::Builder::default().build())
```

## Mobile Plugins

### Biometric

```typescript
import { authenticate } from '@tauri-apps/plugin-biometric';

const result = await authenticate('Authenticate to continue', {
    allowDeviceCredential: true
});
```

### Barcode Scanner

```typescript
import { scan, Format } from '@tauri-apps/plugin-barcode-scanner';

const result = await scan({
    formats: [Format.QRCode],
    windowed: false
});
console.log(result.content);
```

### Haptics

```typescript
import { vibrate, impactFeedback, notificationFeedback } from '@tauri-apps/plugin-haptics';

await vibrate({ duration: 100 });
await impactFeedback('medium');
await notificationFeedback('success');
```

### Geolocation

```typescript
import { getCurrentPosition, watchPosition } from '@tauri-apps/plugin-geolocation';

const position = await getCurrentPosition();
console.log(position.coords.latitude, position.coords.longitude);

const watchId = await watchPosition(
    { enableHighAccuracy: true },
    (position) => console.log(position)
);
```

### NFC

```typescript
import { scan } from '@tauri-apps/plugin-nfc';

const tag = await scan();
console.log(tag.id, tag.records);
```

## Networking Plugins

### HTTP Client

```typescript
import { fetch } from '@tauri-apps/plugin-http';

const response = await fetch('https://api.example.com/data', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ key: 'value' })
});
const data = await response.json();
```

### WebSocket

```typescript
import { WebSocket } from '@tauri-apps/plugin-websocket';

const ws = await WebSocket.connect('wss://example.com/socket');

ws.addListener((message) => {
    console.log('Received:', message);
});

await ws.send('Hello');
await ws.disconnect();
```

## Storage Plugins

### Store (Key-Value)

```typescript
import { Store } from '@tauri-apps/plugin-store';

const store = await Store.load('settings.json');

await store.set('theme', 'dark');
const theme = await store.get('theme');

await store.save(); // Persist to disk
```

### SQL (SQLite/MySQL/PostgreSQL)

```typescript
import Database from '@tauri-apps/plugin-sql';

const db = await Database.load('sqlite:app.db');

await db.execute('CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT)');
await db.execute('INSERT INTO users (name) VALUES (?)', ['Alice']);

const users = await db.select('SELECT * FROM users WHERE name = ?', ['Alice']);
```

### Filesystem

```typescript
import { readTextFile, writeTextFile, readDir, exists } from '@tauri-apps/plugin-fs';
import { BaseDirectory } from '@tauri-apps/api/path';

// Read file
const content = await readTextFile('config.json', { baseDir: BaseDirectory.AppData });

// Write file
await writeTextFile('output.txt', 'Hello', { baseDir: BaseDirectory.AppData });

// Check existence
if (await exists('data', { baseDir: BaseDirectory.AppData })) {
    const entries = await readDir('data', { baseDir: BaseDirectory.AppData });
}
```

## Security Plugins

### Stronghold (Encrypted Storage)

```typescript
import { Stronghold, Location } from '@tauri-apps/plugin-stronghold';

const stronghold = await Stronghold.load('vault.hold', 'password123');
const store = stronghold.loadStore('my-store', []);

const location = Location.generic('vault', 'secret-key');
await store.insert(location, new TextEncoder().encode('secret-value'));

const value = await store.get(location);
```

### Updater

```rust
// src-tauri/src/lib.rs
tauri::Builder::default()
    .plugin(tauri_plugin_updater::Builder::new().build())
```

```typescript
import { check } from '@tauri-apps/plugin-updater';
import { relaunch } from '@tauri-apps/plugin-process';

const update = await check();
if (update) {
    await update.downloadAndInstall();
    await relaunch();
}
```

### Deep Linking

Handle custom URL protocols (e.g., `myapp://open?file=doc.txt`):

```rust
tauri::Builder::default()
    .plugin(tauri_plugin_deep_link::init())
    .setup(|app| {
        #[cfg(any(windows, target_os = "linux"))]
        {
            use tauri_plugin_deep_link::DeepLinkExt;
            app.deep_link().register_all()?;
        }
        Ok(())
    })
```

```typescript
import { onOpenUrl } from '@tauri-apps/plugin-deep-link';

await onOpenUrl((urls) => {
    console.log('Opened with:', urls);
});
```
