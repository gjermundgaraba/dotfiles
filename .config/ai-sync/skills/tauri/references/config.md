# Tauri Configuration Reference

## Table of Contents
- [File Location](#file-location)
- [Required Fields](#required-fields)
- [App Configuration](#app-configuration)
- [Build Configuration](#build-configuration)
- [Bundle Configuration](#bundle-configuration)
- [Security Configuration](#security-configuration)
- [Platform Overrides](#platform-overrides)

## File Location

Configuration lives in `src-tauri/tauri.conf.json`. Alternative formats: `tauri.conf.json5` or `Tauri.toml`.

## Required Fields

```json
{
  "productName": "my-app",
  "identifier": "com.mycompany.myapp",
  "version": "0.1.0"
}
```

- `identifier`: Reverse domain notation, unique app identifier
- `productName`: Display name shown to users
- `version`: Semantic version (or `"../package.json"` to read from package.json)

## App Configuration

```json
{
  "app": {
    "windows": [
      {
        "title": "My App",
        "width": 800,
        "height": 600,
        "resizable": true,
        "fullscreen": false,
        "center": true,
        "decorations": true,
        "transparent": false,
        "url": "index.html"
      }
    ],
    "security": {
      "csp": "default-src 'self'; img-src 'self' data: https:; script-src 'self'"
    },
    "trayIcon": {
      "iconPath": "icons/tray.png",
      "iconAsTemplate": true
    }
  }
}
```

### Window Properties

| Property | Type | Description |
|----------|------|-------------|
| `title` | string | Window title |
| `width` | number | Initial width |
| `height` | number | Initial height |
| `minWidth` | number | Minimum width |
| `minHeight` | number | Minimum height |
| `maxWidth` | number | Maximum width |
| `maxHeight` | number | Maximum height |
| `resizable` | boolean | Allow resizing |
| `fullscreen` | boolean | Start fullscreen |
| `center` | boolean | Center on screen |
| `decorations` | boolean | Show title bar |
| `transparent` | boolean | Transparent background |
| `alwaysOnTop` | boolean | Keep above other windows |
| `visible` | boolean | Initially visible |
| `url` | string | Initial URL to load |

## Build Configuration

```json
{
  "build": {
    "devUrl": "http://localhost:5173",
    "frontendDist": "../dist",
    "beforeDevCommand": "npm run dev",
    "beforeBuildCommand": "npm run build"
  }
}
```

| Property | Description |
|----------|-------------|
| `devUrl` | Dev server URL for hot reload |
| `frontendDist` | Built assets directory or external URL |
| `beforeDevCommand` | Command before `tauri dev` |
| `beforeBuildCommand` | Command before `tauri build` |

## Bundle Configuration

```json
{
  "bundle": {
    "active": true,
    "targets": "all",
    "icon": [
      "icons/32x32.png",
      "icons/128x128.png",
      "icons/128x128@2x.png",
      "icons/icon.icns",
      "icons/icon.ico"
    ],
    "resources": ["resources/*"],
    "category": "Utility",
    "shortDescription": "A short description",
    "longDescription": "A longer description of the app",
    "copyright": "Copyright 2024",
    "macOS": {
      "minimumSystemVersion": "10.13",
      "dmg": {
        "appPosition": { "x": 180, "y": 170 },
        "applicationFolderPosition": { "x": 480, "y": 170 }
      }
    },
    "windows": {
      "webviewInstallMode": {
        "type": "downloadBootstrapper"
      },
      "wix": {
        "language": "en-US"
      }
    },
    "linux": {
      "appimage": {
        "bundleMediaFramework": true
      }
    }
  }
}
```

### Bundle Targets

- `all`: All formats for current platform
- Platform-specific: `app`, `dmg`, `pkg` (macOS), `msi`, `nsis` (Windows), `deb`, `rpm`, `appimage` (Linux)

## Security Configuration

### Capabilities

Define in `src-tauri/capabilities/default.json`:

```json
{
  "$schema": "../gen/schemas/desktop-schema.json",
  "identifier": "default",
  "description": "Default capabilities",
  "windows": ["main"],
  "permissions": [
    "core:default",
    "shell:allow-open",
    "dialog:allow-open",
    "fs:default"
  ]
}
```

### Common Permissions

| Permission | Description |
|------------|-------------|
| `core:default` | Core functionality |
| `shell:allow-open` | Open URLs in browser |
| `dialog:allow-open` | Open file dialogs |
| `dialog:allow-save` | Save file dialogs |
| `fs:default` | Filesystem access |
| `fs:allow-read` | Read files |
| `fs:allow-write` | Write files |
| `clipboard:allow-read` | Read clipboard |
| `clipboard:allow-write` | Write clipboard |
| `notification:default` | Send notifications |

### Content Security Policy

```json
{
  "app": {
    "security": {
      "csp": {
        "default-src": "'self'",
        "script-src": "'self'",
        "style-src": "'self' 'unsafe-inline'",
        "img-src": "'self' data: https:",
        "connect-src": "'self' https://api.example.com"
      }
    }
  }
}
```

## Platform Overrides

Create platform-specific config files:

- `tauri.linux.conf.json`
- `tauri.macos.conf.json`
- `tauri.windows.conf.json`

These merge with the base configuration.

```json
// tauri.macos.conf.json
{
  "bundle": {
    "macOS": {
      "entitlements": "./Entitlements.plist"
    }
  }
}
```
