#!/bin/bash
set -euo pipefail

# Unified script to create symlinks to built global rule files for various platforms

AI_RULES_DIR="$HOME/.config/ai-rules"

create_symlinks_for_platform() {
    local platform="$1"
    local globals_dir
    local dest_dir
    local symlink_ext

    case "$platform" in
        cursor)
            globals_dir="$AI_RULES_DIR/build/cursor"
            dest_dir=".cursor/rules"
            symlink_ext="mdc"
            ;;
        windsurf)
            globals_dir="$AI_RULES_DIR/build/windsurf"
            dest_dir=".windsurf/rules"
            # Windsurf uses .md symlink names pointing to .mdc source files
            symlink_ext="md"
            ;;
        qoder)
            globals_dir="$AI_RULES_DIR/build/qoder"
            dest_dir=".qoder/rules"
            symlink_ext="mdc"
            ;;
        claude)
            echo "No symlink destination is defined for 'claude'. Skipping."
            return 0
            ;;
        *)
            echo "Unknown platform: $platform" >&2
            return 1
            ;;
    esac

    mkdir -p "$dest_dir"

    if [ ! -d "$globals_dir" ] || ! ls "$globals_dir"/*.mdc >/dev/null 2>&1; then
        echo "No built $platform rule files found in $globals_dir. Run 'just build-rules-$platform' first." >&2
        return 1
    fi

    echo "Cleaning up existing global rule symlinks in $dest_dir..."
    for existing_symlink in "$dest_dir"/global_rule_*; do
        if [ -L "$existing_symlink" ]; then
            echo "Removing existing symlink: $(basename "$existing_symlink")"
            rm "$existing_symlink"
        fi
    done

    echo "Creating symlinks to global rules in $dest_dir..."
    for file in "$globals_dir"/*.mdc; do
        [ ! -f "$file" ] && continue

        basename=$(basename "$file")
        name_without_ext="${basename%.*}"
        symlink_name="global_rule_${name_without_ext}.$symlink_ext"
        symlink_path="$dest_dir/$symlink_name"

        echo "Creating symlink: $symlink_path -> $file"
        ln -s "$file" "$symlink_path"
    done

    echo "Done! Global rule symlinks created in $dest_dir"
}

if [ $# -lt 1 ]; then
    echo "Usage: $(basename "$0") {cursor|windsurf|qoder|claude|all}" >&2
    exit 1
fi

case "$1" in
    cursor)
        create_symlinks_for_platform "cursor"
        ;;
    windsurf)
        create_symlinks_for_platform "windsurf"
        ;;
    qoder)
        create_symlinks_for_platform "qoder"
        ;;
    claude)
        create_symlinks_for_platform "claude"
        ;;
    all)
        create_symlinks_for_platform "cursor"
        create_symlinks_for_platform "windsurf"
        create_symlinks_for_platform "qoder"
        create_symlinks_for_platform "claude"
        ;;
    *)
        echo "Unknown platform: $1" >&2
        echo "Usage: $(basename "$0") {cursor|windsurf|qoder|claude|all}" >&2
        exit 1
        ;;
esac


