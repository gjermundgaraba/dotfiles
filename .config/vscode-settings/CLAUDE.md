# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

This is a VSCode/Cursor configuration repository using `just` (justfile) for task management.

- `just set-up-profile-symlinks-cursor` - Creates symlinks for config/settings.json and config/keybindings.json to Cursor's user profile directory
- `just install-extensions-cursor` - Installs all extensions listed in config/extensions.json using the Cursor CLI
- `just format-keybindings` - Formats config/keybindings.json with proper grouping (enables/disables) and sorting

Python environment setup is handled automatically by the format-keybindings task using a virtual environment with json5 dependency.

## Architecture

This repository manages VSCode/Cursor editor configuration as code:

- **config/settings.json**: Main editor settings including Go, Vim, and language server configurations
- **config/keybindings.json**: Custom key bindings organized into "enables" and "disables" sections
- **config/extensions.json**: List of required extensions for consistent development environment
- **scripts/format_keybindings.py**: Python script that automatically formats and organizes keybindings by type and key

The configuration is designed for:
- Go development with golangci-lint integration
- Vim-style editing with custom leader key mappings
- Multi-cursor editing shortcuts
- Terminal and navigation optimizations

## Key Patterns

- Uses justfile for cross-platform task automation
- Separates keybindings into logical groups (enables vs disables)
- Maintains symlinks to actual editor config directories for live updates
- Includes comprehensive extension list for full development environment setup