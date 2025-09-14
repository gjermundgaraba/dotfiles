#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$HOME/.config/aerospace"
TEMPLATE="$CONFIG_DIR/aerospace.template.toml"
OUT_L="$CONFIG_DIR/aerospace.laptop.toml"
OUT_D="$CONFIG_DIR/aerospace.desktop.toml"

if ! command -v gomplate >/dev/null 2>&1; then
  echo "gomplate not found. Install with: brew install gomplate" >&2
  exit 1
fi

if [ ! -f "$TEMPLATE" ]; then
  echo "Template not found: $TEMPLATE" >&2
  exit 1
fi

AEROSPACE_MODE=laptop gomplate -f "$TEMPLATE" -o "$OUT_L"
AEROSPACE_MODE=desktop gomplate -f "$TEMPLATE" -o "$OUT_D"

# Optional validation: ensure exactly one 'top =' line in each output
for f in "$OUT_L" "$OUT_D"; do
  count=$(grep -E '^[[:space:]]*top[[:space:]]*=' "$f" | wc -l | tr -d ' ')
  if [ "$count" -ne 1 ]; then
    echo "Validation failed for $f: expected exactly one 'top =' line, got $count" >&2
    exit 1
  fi
done

echo "Rendered:"
echo "  $OUT_L"
echo "  $OUT_D"
