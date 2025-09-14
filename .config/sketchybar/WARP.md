# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Overview
- Purpose: macOS SketchyBar configuration written in Lua, with small helper binaries in C.
- Entrypoint: sketchybarrc (Lua shebang). It requires `helpers` (which auto-builds native helpers) and `init.lua` (boots the SketchyBar Lua runtime and loads the rest of the config).

Docs
- General sketchybar docs: https://felixkratz.github.io/SketchyBar/
- SketchyBar Lua Example: https://github.com/FelixKratz/SbarLua/tree/main/example
- SketchyBar Lua Source code: https://github.com/FelixKratz/SbarLua/tree/main/src

Common commands and setup
- Dependencies:
  - `brew install --cask font-sketchybar-app-font`
  - `brew install switchaudio-osx`
  - `brew install --cask nikitabobko/tap/aerospace`
  - `nowplaying-cli` (required by `items/media.lua`) — ensure it is installed and in PATH
- Build helper binaries (event providers):
  - `make -C helpers`
  - Optional individual rebuilds: `make -C helpers/event_providers/network_load` and `make -C helpers/event_providers/cpu_load`
  - Note: `helpers/init.lua` runs `make` in `helpers` automatically when SketchyBar loads this config.
- Development loop:
  - Hot reload is currently disabled (in `init.lua` the `sbar.hotload(true)` line is commented out). To enable hot reloading, uncomment it or run `sketchybar --hotload on`. You can also apply changes with `sketchybar --reload`.

Common operations

- SketchyBar CLI quick reference
  - Add an item at a position:
    ```bash
    sketchybar --add item demo.left left
    ```
  - Set nested properties on an item:
    ```bash
    sketchybar --set demo.left icon="" label="Hello" label.drawing=on padding_left=4
    ```
  - Subscribe an item to events:
    ```bash
    sketchybar --subscribe demo.left front_app_switched space_windows_change
    ```
  - Create and trigger a custom event with payload:
    ```bash
    sketchybar --add event send_message
    sketchybar --trigger send_message MESSAGE='Hello' HOLD=true
    ```
  - Query bar, item, defaults, and events:
    ```bash
    sketchybar --query bar
    sketchybar --query demo.left
    sketchybar --query defaults
    sketchybar --query events
    ```
  - Animate a property change:
    ```bash
    sketchybar --animate tanh 8 --set demo.left y_offset=-4
    sketchybar --animate tanh 8 --set demo.left y_offset=0
    ```
  - Toggle an item popup:
    ```bash
    sketchybar --set demo.left popup.drawing=toggle
    ```
  - Clone and remove (order: parent then new name):
    ```bash
    sketchybar --clone demo.left demo.clone
    sketchybar --remove demo.left demo.clone
    ```
  - Configure bar and defaults:
    ```bash
    sketchybar --bar height=41
    sketchybar --default label.padding_left=4
    ```
  - Reload config and toggle hotload:
    ```bash
    sketchybar --reload
    sketchybar --hotload on
    ```

- SbarLua quick reference
  - Add an item and set properties:
    ```lua
    local sbar = require("sketchybar")
    local item = sbar.add("item", "demo.lua", { position = "right", icon = { string = "" }, label = { string = "Hello" } })
    item:set({ label = { drawing = true }, padding_left = 4 })
    ```
  - Subscribe to events (env contains useful fields like BUTTON, INFO, NAME):
    ```lua
    item:subscribe("mouse.clicked", function(env)
      local right = env.BUTTON == "right"
      item:set({ icon = { string = right and "" or "" } })
    end)
    ```
  - Trigger a custom event from Lua (via CLI):
    ```lua
    sbar.exec("sketchybar --trigger send_message MESSAGE='From Lua' HOLD=true")
    ```
  - Query current state and remove:
    ```lua
    local state = item:query()
    sbar.remove("demo.lua")
    ```
  - Popup content and toggle:
    ```lua
    local popup = sbar.add("item", { position = "popup." .. item.name, label = { string = "Details" } })
    item:set({ popup = { drawing = "toggle" } })
    ```
  - Bar/default configuration from Lua:
    ```lua
    sbar.default({ label = { padding_left = 4 } })
    sbar.bar({ height = 41 })
    ```
  - Animations, delays, and shell execution:
    ```lua
    sbar.animate("tanh", 8, function()
      item:set({ y_offset = -4 })
      item:set({ y_offset = 0 })
    end)
    sbar.delay(1, function() end)

    sbar.exec("pmset -g batt", function(out)
      -- parse output and update item
    end)
    ```

High-level architecture and structure
- Boot sequence
  - `sketchybarrc`: Lua entrypoint; requires `helpers` and `init`.
  - `helpers/init.lua`: adds the SketchyBar Lua module to `package.cpath` and runs `make` in `helpers` to build helper binaries.
  - `init.lua`: extends `package.cpath` for `~/.local/share/sketchybar_lua`, calls `sbar.begin_config()`, can enable hotload (currently commented out), requires `bar.lua`, `default.lua`, and `items/init.lua`, then ends config and starts `sbar.event_loop()`.
- Styling and resources
  - `colors.lua`: Catppuccin-derived palette; provides sections (bar, item, popup, plus per-item colors). Includes `with_alpha` helper that works under LuaJIT/5.4.
  - `settings.lua`: global paddings and font family via `helpers/default_font.lua` (e.g., BerkeleyMono Nerd Font Mono).
  - `icons.lua`: glyphs used by items (Nerd Font and sketchybar-app-font).
- Bar defaults and frame
  - `bar.lua`: global bar appearance (height, blur, border, background color, etc.) using `colors.sections.bar`.
  - `default.lua`: default styles for all items (icon/label fonts, padding, backgrounds, popup styles, shadows, etc.).
- Items (composed in `items/init.lua`)
  - Left: `items/apple.lua` (Apple icon with click animation), `items/spaces.lua` (dynamic workspaces powered by Aerospace).
    - `spaces.lua`: queries workspaces (`aerospace list-workspaces`), creates items per workspace, and shows app icons per space via `helpers/app_icons.lua`. Click switches workspace (`aerospace workspace N`). Tracks focus (`aerospace_workspace_change`).
  - Center: `items/notifications.lua` (temporary popup messages via custom events `send_message`/`hide_message`).
  - Right: `items/calendar.lua` (time label with Calendar app click-through), `items/widgets` (volume and battery), `items/wifi.lua` (Wi‑Fi status and popup), `items/media.lua` (now playing with popup transport controls).
    - `widgets/volume.lua`: uses `SwitchAudioSource` (from `switchaudio-osx`) to query/set output device, `osascript` to change volume, and a popup slider + device list. Right-click opens macOS Sound settings.
    - `widgets/battery.lua`: queries `pmset -g batt`; displays charge state and a popup with remaining time.
    - `wifi.lua`: spawns `helpers/event_providers/network_load/bin/network_load` to emit periodic `network_update` events; shows SSID with popup fields (IP, Router); includes clipboard copy on click.
    - `media.lua`: listens for `media_change`; relies on `nowplaying-cli` for playback control (previous/toggle/next) and whitelists Spotify/Psst.
- Helpers and native event providers
  - `helpers/event_providers/*`: small C programs compiled with `clang` (see makefiles) that register SketchyBar events and periodically emit metrics.
    - `cpu_load`: builds `bin/cpu_load` (present but not referenced elsewhere in this config).
    - `network_load`: builds `bin/network_load` used by `items/wifi.lua` (interface `en0`, event name `network_update`, frequency `2.0`).

Notes on environment
- Platform assumptions: macOS (uses `pmset`, `ipconfig`, `networksetup`, `scutil`, `osascript`) and SketchyBar’s Lua API (`~/.local/share/sketchybar_lua`).
- Fonts: icons use Nerd Font glyphs defined in `icons.lua`; `sketchybar-app-font` is used selectively (e.g., some labels in `items/spaces.lua`); default text fonts come from `helpers/default_font.lua`.

There is no test suite or lint configuration in this repository. Development typically involves editing Lua modules and live-reloading via SketchyBar.

