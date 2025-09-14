# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Docs
- If this file doesn't contain a specific configuration option, refer to the docs: https://nikitabobko.github.io/AeroSpace/guide
- Commands reference: https://nikitabobko.github.io/AeroSpace/commands
- Extra examples: https://nikitabobko.github.io/AeroSpace/goodies

Repository scope
- This repository manages AeroSpace configuration via a single template and generated outputs, with a symlink selecting the active config:
  - Source-of-truth template: `~/.config/aerospace/aerospace.template.toml` (EDIT THIS FILE)
  - Generated outputs (do not edit): `~/.config/aerospace/aerospace.laptop.toml`, `~/.config/aerospace/aerospace.desktop.toml`
  - Active config (symlink, do not edit): `~/.config/aerospace/aerospace.toml` -> one of the generated outputs
- The config defines tiling/layout behavior, keybindings (via binding modes), workspace rules, and integrates with SketchyBar and a local helper script.

Templating and editing policy
- Templating engine: gomplate (install via `brew install gomplate`).
- Template switch: the template reads `AEROSPACE_MODE` to set mode-specific options. Example used here: outer gap top size.
  - Laptop mode: `top = 15`
  - Desktop mode: `top = 45`
- Render configs from the template:
  - Using just: `just render`
  - Direct script: `~/.config/aerospace/scripts/render_configs.sh`
  - The render script validates that each output contains exactly one `top =` line.
- Switch active config (updates the `aerospace.toml` symlink and reloads AeroSpace):
  - `~/.config/aerospace/scripts/switch_config.sh laptop`
  - `~/.config/aerospace/scripts/switch_config.sh desktop`
- Do not edit `aerospace.toml` or the generated files directly. Always edit `aerospace.template.toml`, then render and switch as needed.

CLI quick reference (docs-verified)
- Version/help:
  
  ```bash
  aerospace --version
  aerospace --help
  ```

- Apply config changes without restarting the app:
  
  ```bash
  aerospace reload-config
  ```

- Common commands to test behaviors (from the Commands section in the docs):
  
  ```bash
  # Focus/move
  aerospace focus left
  aerospace move right
  
  # Resize
  aerospace resize smart -50
  aerospace resize smart +50
  
  # Layout and fullscreen
  aerospace layout floating tiling
  aerospace fullscreen
  aerospace macos-native-fullscreen on
  aerospace macos-native-fullscreen off
  aerospace macos-native-minimize
  
  # Workspaces/monitors
  aerospace workspace 2
  aerospace move-node-to-workspace V
  aerospace move-node-to-monitor next
  aerospace focus-monitor next
  aerospace workspace-back-and-forth
  aerospace move-workspace-to-monitor --wrap-around next
  
  # Binding modes
  aerospace mode service
  aerospace mode main
  
  # Join/Swap
  aerospace join-with right
  aerospace swap left
  ```

Note: exec-and-forget is available in config only (not via CLI).

- Observe runtime logs for the AeroSpace process:
  
  ```bash
  log stream --style compact --predicate 'process == "Aerospace"'
  ```

- Manually trigger SketchyBar events used by this config (for testing UI updates):
  
  ```bash
  sketchybar --trigger aerospace_focus_change
  sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=1
  ```

Query commands (docs-verified)

```bash
# Introspection
aerospace list-workspaces --monitor mouse --visible
aerospace list-monitors
aerospace list-windows
aerospace list-apps
aerospace list-modes
aerospace list-exec-env-vars

# Config/debug
aerospace config
aerospace debug-windows
```

Config locations and defaults (from docs)
- AeroSpace looks for config in standard locations. If found in more than one location, it reports ambiguity.
- You can bootstrap from the default config included with the app:
  
  ```bash
  cp /Applications/AeroSpace.app/Contents/Resources/default-config.toml ~/.aerospace.toml
  ```

High-level architecture of this config
- Global options
  - Layout and orientation defaults: `default-root-container-layout = "tiles"`, `default-root-container-orientation = "auto"` (auto: wide → horizontal, tall → vertical)
  - Normalization is enabled (`enable-normalization-*`) for consistent container trees
  - Gaps: small inner/outer gaps; `top` differs by mode (15 laptop, 45 desktop)
  - `start-at-login = true`

- Event hooks
  - `exec-on-workspace-change`: triggers SketchyBar with `AEROSPACE_FOCUSED_WORKSPACE`
  - `on-focus-changed`: centers mouse on focused window and triggers a SketchyBar update
  - `on-focused-monitor-changed`: recenters mouse on the active monitor

- Workspace ↔ monitor mapping
  - `[workspace-to-monitor-force-assignment]` binds workspaces to specific displays (e.g., `S` → Built-in Retina, `V` → DELL U3425WE). Update names if they differ on your system

- Modes and keybindings (big picture)
  - `mode.main` (Alt-based):
    - Workspace selection: Alt-1..4, Alt-S, Alt-V; quick swap: Alt-Tab
    - Focus movement: Alt-H/J/K/L; Move windows: Alt-Shift-H/J/K/L
    - Layout toggles: Alt-`,` / Alt-`.` / Alt-`/`; Fullscreen: Alt-F
    - Enter resize mode: Alt-R; Enter service mode: Alt-Shift-;
  - Function keys F1..F12:
    - Call `/Users/gg/.local/bin/aerospace-focus-app` to focus specific apps; F12 opens Warp ("new")
  - `mode.resize`:
    - Smart +/- resizing and balance; exit with Esc
  - `mode.service`:
    - Join-with (merge containers), `reload-config` (Esc), floating↔tiling toggle, flatten tree, volume controls, close all but current

- App/window rules (`[[on-window-detected]]`)
  - Workspace routing for Slack/Linear (workspace 1), Spotify (S), Granola/Cron (V)
  - Floating layout exceptions for Finder, Notes, Notion, 1Password, Preview, MacVirt
  - Startup defaults: enforce `layout tiling` for workspaces `1-4, S, V` during AeroSpace startup

Common configuration options (quick reference)
- Layout and tree
  - `accordion-padding = <int>`
  - `default-root-container-layout = 'tiles' | 'accordion'`
  - `default-root-container-orientation = 'horizontal' | 'vertical' | 'auto'`
  - `enable-normalization-flatten-containers = <bool>`
  - `enable-normalization-opposite-orientation-for-nested-containers = <bool>`

- Gaps
  - `[gaps.inner] horizontal|vertical = <int>`
  - `[gaps.outer] top|right|bottom|left = <int>`

- Startup and mapping
  - `start-at-login = <bool>`
  - `[workspace-to-monitor-force-assignment]` = map workspace names to display names

- Keyboard and bindings
  - `[key-mapping] preset = 'qwerty'` (see docs for other layouts)
  - Binding modes must include `mode.main.binding` (required by docs); additional modes like `mode.resize.binding`, `mode.service.binding`

- Callbacks and rules
  - `exec-on-workspace-change = [ ... ]`
  - `on-focus-changed = [ ... ]`
  - `on-focused-monitor-changed = [ ... ]`
  - `[[on-window-detected]]` rules with conditions like `if.app-id`, `if.workspace`, `if.during-aerospace-startup` and `run = [ ... ]`

- exec-* environment variables (docs)
  - Commands executed via `exec*` can receive environment vars. This config uses `AEROSPACE_FOCUSED_WORKSPACE` with SketchyBar. Other context vars are available in the docs for exec callbacks.

Goodies quick recipes (from docs)
- Move windows by dragging any part of the window:
  
  ```bash
  defaults write -g NSWindowShouldDragOnGesture -bool true
  ```

- Disable windows opening animations:
  
  ```bash
  defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
  ```

- Trackpad gestures to switch workspaces (assign these to your gesture tool):
  
  ```bash
  aerospace workspace "$(aerospace list-workspaces --monitor mouse --visible)" && aerospace workspace next
  aerospace workspace "$(aerospace list-workspaces --monitor mouse --visible)" && aerospace workspace prev
  ```

- SketchyBar integration examples and more goodies: https://nikitabobko.github.io/AeroSpace/goodies

External integrations and local dependencies
- SketchyBar: UI updates via `--trigger aerospace_focus_change` and `aerospace_workspace_change`
- Local helper script: `/Users/gg/.local/bin/aerospace-focus-app` (required for F1..F12 app focusing); ensure it exists or adjust bindings

Operational notes specific to this repo
- Edit `~/.config/aerospace/aerospace.template.toml` (not the generated files).
- Regenerate with `just render` or `~/.config/aerospace/scripts/render_configs.sh`.
- Switch active mode with `~/.config/aerospace/scripts/switch_config.sh laptop|desktop` (this updates the symlink and runs `aerospace reload-config`).
- Verify the active symlink: `ls -l ~/.config/aerospace/aerospace.toml`.
- If external display names change, update `[workspace-to-monitor-force-assignment]` in the template.
- macOS Mission Control: Display/workspace behavior depends on arrangement and whether “Displays have separate Spaces” is enabled; see the docs’ notes if workspace/monitor routing behaves unexpectedly.
- If function key focusing fails, verify the helper script path and app names/bundle IDs.

