# Tauri CLI Reference

## Table of Contents
- [Installation](#installation)
- [Development Commands](#development-commands)
- [Build Commands](#build-commands)
- [Mobile Commands](#mobile-commands)
- [Plugin Commands](#plugin-commands)
- [Utility Commands](#utility-commands)

## Installation

```bash
# npm
npm install -D @tauri-apps/cli

# yarn
yarn add -D @tauri-apps/cli

# pnpm
pnpm add -D @tauri-apps/cli

# cargo
cargo install tauri-cli
```

## Development Commands

### tauri init

Initialize Tauri in an existing project:

```bash
npx tauri init
```

Prompts for:
- App name
- Window title
- Frontend dev server URL
- Frontend dist directory
- Dev command
- Build command

### tauri dev

Run app in development mode with hot-reload:

```bash
npx tauri dev

# Options
npx tauri dev --release        # Build in release mode
npx tauri dev --target <target> # Specific Rust target
npx tauri dev --features <feat> # Enable Cargo features
npx tauri dev --no-watch       # Disable file watching
npx tauri dev --port 3000      # Override dev server port
```

### tauri info

Display environment and project information:

```bash
npx tauri info
```

Shows: OS, Rust version, Node version, Tauri versions, webview info.

## Build Commands

### tauri build

Build for production:

```bash
npx tauri build

# Options
npx tauri build --debug              # Include debug symbols
npx tauri build --target <target>    # Cross-compile
npx tauri build --bundles <formats>  # Specific formats
npx tauri build --no-bundle          # Skip bundling
npx tauri build --ci                 # CI mode (skip prompts)
npx tauri build --features <feat>    # Enable Cargo features
```

### Bundle Formats

```bash
# macOS
npx tauri build --bundles app,dmg

# Windows
npx tauri build --bundles msi,nsis

# Linux
npx tauri build --bundles deb,rpm,appimage
```

### tauri bundle

Bundle a pre-built binary:

```bash
npx tauri bundle --bundles deb,appimage
```

## Mobile Commands

### Android

```bash
# Initialize Android project
npx tauri android init

# Development
npx tauri android dev
npx tauri android dev --open  # Open in Android Studio

# Build
npx tauri android build
npx tauri android build --apk      # Build APK
npx tauri android build --aab      # Build AAB (Play Store)
npx tauri android build --split-per-abi  # Per-ABI builds
```

### iOS

```bash
# Initialize iOS project
npx tauri ios init

# Development
npx tauri ios dev
npx tauri ios dev --open  # Open in Xcode

# Build
npx tauri ios build
npx tauri ios build --export-method app-store
```

## Plugin Commands

### tauri add

Add a plugin to the project:

```bash
npx tauri add <plugin-name>

# Examples
npx tauri add shell
npx tauri add dialog
npx tauri add fs
npx tauri add store
npx tauri add sql
```

### tauri remove

Remove a plugin:

```bash
npx tauri remove <plugin-name>
```

### tauri plugin

Plugin development commands:

```bash
# Create new plugin
npx tauri plugin new <name>

# Initialize plugin in existing directory
npx tauri plugin init

# Add Android support
npx tauri plugin android init

# Add iOS support
npx tauri plugin ios init
```

## Utility Commands

### tauri icon

Generate app icons from source image:

```bash
npx tauri icon <path-to-icon>
npx tauri icon icon.png          # Generate all icons
npx tauri icon icon.png -o icons # Output to specific dir
```

Source should be 1024x1024 PNG with transparency.

### tauri signer

Manage signing keys for updates:

```bash
# Generate new keypair
npx tauri signer generate -w ~/.tauri/myapp.key

# Sign a file
npx tauri signer sign path/to/file -k ~/.tauri/myapp.key
```

### tauri migrate

Migrate from Tauri v1 to v2:

```bash
npx tauri migrate
```

### tauri permission

Manage permissions:

```bash
# List available permissions
npx tauri permission list

# Add permission to capability
npx tauri permission add <permission> --capability <name>
```

### tauri capability

Manage capabilities:

```bash
# Create new capability
npx tauri capability new <name>
```

### tauri completions

Generate shell completions:

```bash
npx tauri completions bash > ~/.bash_completion.d/tauri
npx tauri completions zsh > ~/.zsh/completions/_tauri
npx tauri completions fish > ~/.config/fish/completions/tauri.fish
npx tauri completions powershell > tauri.ps1
```

## Common Workflows

### New Project

```bash
# Quick start
npm create tauri-app@latest

# Or manual
npm create vite@latest my-app -- --template react-ts
cd my-app
npm install
npm install -D @tauri-apps/cli
npx tauri init
npx tauri dev
```

### Production Build

```bash
# Install deps and build frontend
npm install
npm run build

# Build Tauri app
npx tauri build
```

### Cross-Platform Build

```bash
# Build for specific target
npx tauri build --target x86_64-pc-windows-msvc
npx tauri build --target aarch64-apple-darwin
npx tauri build --target x86_64-unknown-linux-gnu
```
