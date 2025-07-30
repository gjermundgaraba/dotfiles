# VSCode/Cursor Settings

Configuration-as-code for VSCode and Cursor editors.

## Commands

- `just set-up-profile-symlinks-cursor` - Creates symlinks from this repo's config/settings.json and config/keybindings.json to Cursor's profile directory
- `just install-extensions-cursor` - Reads config/extensions.json and installs each extension via Cursor CLI
- `just format-keybindings` - Runs scripts/format_keybindings.py to organize config/keybindings.json into sorted enables/disables sections

## Files

- `config/settings.json` - Main editor configuration
- `config/keybindings.json` - Custom keyboard shortcuts
- `config/extensions.json` - List of required extensions
- `scripts/format_keybindings.py` - Python script for organizing keybindings
- `justfile` - Task runner with setup commands