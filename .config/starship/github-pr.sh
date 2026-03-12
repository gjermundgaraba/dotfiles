#!/bin/bash
# Outputs the current branch's PR number as a clickable terminal hyperlink.
# Uses a cache to avoid hitting the GitHub API on every prompt.

repo=$(git rev-parse --show-toplevel 2>/dev/null) || exit
branch=$(git branch --show-current 2>/dev/null) || exit
hash=$(echo "$repo:$branch" | md5 -q)
cache="/tmp/starship-pr-${hash}"

# Background refresh if cache is missing or older than 2 minutes
if [ ! -f "$cache" ] || [ $(($(date +%s) - $(stat -f %m "$cache"))) -gt 120 ]; then
  (gh pr view --json number,url -q '"\(.url) \(.number)"' > "${cache}.tmp" 2>/dev/null \
    && mv "${cache}.tmp" "$cache" \
    || rm -f "${cache}.tmp" "$cache") &
fi

# Read from cache
if [ -f "$cache" ] && [ -s "$cache" ]; then
  read -r url number < "$cache"
  [ -n "$number" ] && echo "#${number}"
fi
