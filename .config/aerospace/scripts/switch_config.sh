#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $(basename "$0") laptop|desktop" >&2
  exit 2
}

MODE="${1:-}"
case "$MODE" in
  laptop|desktop) ;;
  *) usage ;;
 esac

CONFIG_DIR="$HOME/.config/aerospace"
TARGET="$CONFIG_DIR/aerospace.${MODE}.toml"
LINK="$CONFIG_DIR/aerospace.toml"

if [ ! -f "$TARGET" ]; then
  echo "Target config not found: $TARGET" >&2
  echo "Run: $CONFIG_DIR/scripts/render_configs.sh" >&2
  exit 1
fi

ln -sfn "$TARGET" "$LINK"

if command -v aerospace >/dev/null 2>&1; then
  aerospace reload-config
else
  echo "Warning: 'aerospace' CLI not found in PATH; symlink updated but config not reloaded." >&2
fi

echo "Switched to $MODE config -> $(readlink "$LINK")"
