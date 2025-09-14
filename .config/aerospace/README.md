# AeroSpace dual-configs via gomplate

This setup lets you keep a single source-of-truth template for your AeroSpace config and generate two concrete configs: one for laptop-only and one for desktop/external-monitor setups. A small script swaps which config is active via a symlink and reloads AeroSpace.

## Files

- aerospace.template.toml
  - Single source-of-truth. Uses gomplate to choose values based on the AEROSPACE_MODE environment variable.
- aerospace.laptop.toml, aerospace.desktop.toml
  - Generated outputs from the template.
- aerospace.toml
  - Symlink to the active generated config (laptop or desktop).
- scripts/render_configs.sh
  - Renders both configs with gomplate.
- scripts/switch_config.sh
  - Updates the aerospace.toml symlink to the selected config and runs `aerospace reload-config`.
- Justfile
  - Provides a `render` recipe to regenerate the configs from the template.

## Prerequisites

- gomplate installed and available in PATH
  - Install: `brew install gomplate`
- AeroSpace CLI available (for switching): `aerospace reload-config`

## How it works

The template aerospace.template.toml contains a conditional for the outer top gap:

- When AEROSPACE_MODE=laptop -> top = 15
- When AEROSPACE_MODE=desktop -> top = 45

The render script runs gomplate twice, once per mode, to produce the two concrete config files.

## Commands

- Render both configs from the template:
  - Using just: `just render`
  - Direct script: `./scripts/render_configs.sh`

- Switch the active config (updates symlink and reloads AeroSpace):
  - Laptop: `./scripts/switch_config.sh laptop`
  - Desktop: `./scripts/switch_config.sh desktop`

## Typical workflow

1) Edit aerospace.template.toml as needed (keep shared settings here; gate differences with `AEROSPACE_MODE`).
2) Regenerate configs:
   - `just render` (or `./scripts/render_configs.sh`).
3) Activate the desired mode:
   - `./scripts/switch_config.sh laptop` or `./scripts/switch_config.sh desktop`.

## Troubleshooting

- gomplate not found:
  - Install with Homebrew: `brew install gomplate`.
- Verify symlink target:
  - `ls -l aerospace.toml` (should point to `aerospace.laptop.toml` or `aerospace.desktop.toml`).
- Force reload AeroSpace if needed:
  - `aerospace reload-config`.

