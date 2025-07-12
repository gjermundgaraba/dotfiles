#!/bin/bash

# Script to create symlinks to global rule files in .cursor/.rules/

set -e

AI_RULES_DIR="$HOME/.config/ai-rules"
GLOBALS_DIR="$AI_RULES_DIR/rules/the-engineer"
CURSOR_RULES_DIR=".cursor/rules"

mkdir -p "$CURSOR_RULES_DIR"

echo "Cleaning up existing global rule symlinks..."
for existing_symlink in "$CURSOR_RULES_DIR"/global_rule_*; do
    if [ -L "$existing_symlink" ]; then
        echo "Removing existing symlink: $(basename "$existing_symlink")"
        rm "$existing_symlink"
    fi
done

echo "Creating symlinks to global rules in $CURSOR_RULES_DIR..."

for file in "$GLOBALS_DIR"/*; do
    [ ! -f "$file" ] && continue
    
    basename=$(basename "$file")
    name_without_ext="${basename%.*}"
    symlink_name="global_rule_${name_without_ext}.mdc"
    symlink_path="$CURSOR_RULES_DIR/$symlink_name"
    
    echo "Creating symlink: $symlink_path -> $file"
    ln -s "$file" "$symlink_path"
done

echo "Done! Global rule symlinks created in $CURSOR_RULES_DIR"