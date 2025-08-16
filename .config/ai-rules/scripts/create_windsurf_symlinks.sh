#!/bin/bash

# Script to create symlinks to built Windsurf rule files in .windsurf/rules/

set -e

AI_RULES_DIR="$HOME/.config/ai-rules"
GLOBALS_DIR="$AI_RULES_DIR/build/windsurf"
WINDSURF_RULES_DIR=".windsurf/rules"

mkdir -p "$WINDSURF_RULES_DIR"

if [ ! -d "$GLOBALS_DIR" ] || ! ls "$GLOBALS_DIR"/*.mdc >/dev/null 2>&1; then
    echo "No built Windsurf rule files found in $GLOBALS_DIR. Run 'just build-rules-windsurf' first." >&2
    exit 1
fi

echo "Cleaning up existing global rule symlinks..."
for existing_symlink in "$WINDSURF_RULES_DIR"/global_rule_*; do
    if [ -L "$existing_symlink" ]; then
        echo "Removing existing symlink: $(basename "$existing_symlink")"
        rm "$existing_symlink"
    fi
done

echo "Creating symlinks to global rules in $WINDSURF_RULES_DIR..."

for file in "$GLOBALS_DIR"/*.mdc; do
    [ ! -f "$file" ] && continue

    basename=$(basename "$file")
    name_without_ext="${basename%.*}"
    symlink_name="global_rule_${name_without_ext}.mdc"
    symlink_path="$WINDSURF_RULES_DIR/$symlink_name"

    echo "Creating symlink: $symlink_path -> $file"
    ln -s "$file" "$symlink_path"
done

echo "Done! Global rule symlinks created in $WINDSURF_RULES_DIR"


