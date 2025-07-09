#!/bin/bash

# Script to create symlinks to global rule files in .cursor/.rules/

set -e

AI_RULES_DIR="$HOME/.config/ai-rules"
GLOBALS_DIR="$AI_RULES_DIR/globals"
CURSOR_RULES_DIR=".cursor/rules"

mkdir -p "$CURSOR_RULES_DIR"

echo "Creating symlinks to global rules in $CURSOR_RULES_DIR..."

for file in "$GLOBALS_DIR"/*; do
    [ ! -f "$file" ] && continue
    
    basename=$(basename "$file")
    name_without_ext="${basename%.*}"
    symlink_name="global_rule_${name_without_ext}.mdc"
    symlink_path="$CURSOR_RULES_DIR/$symlink_name"
    
    if [ -L "$symlink_path" ]; then
        echo "Removing existing symlink: $symlink_name"
        rm "$symlink_path"
    elif [ -f "$symlink_path" ]; then
        echo "Warning: $symlink_name exists as a regular file, skipping..."
        continue
    fi
    
    echo "Creating symlink: $symlink_name -> $file"
    ln -s "$file" "$symlink_path"
done

echo "Done! Global rule symlinks created in $CURSOR_RULES_DIR"