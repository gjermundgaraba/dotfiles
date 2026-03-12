#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Get git branch if in a git repo (skip optional locks for performance)
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" -c core.useReplaceRefs=false symbolic-ref --short HEAD 2>/dev/null || echo "detached")
    git_info=" [git: $branch]"
else
    git_info=""
fi

# Format context usage
if [ -n "$remaining" ]; then
    context_info=" | Context: ${remaining}% remaining"
else
    context_info=""
fi

# Display the status line
printf "%s | %s%s%s" "$model" "$cwd" "$git_info" "$context_info"
