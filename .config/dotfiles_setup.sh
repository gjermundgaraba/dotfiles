#!/bin/bash

# H1: Brew installs
# TODO: Add all my packages here (at the very leasy the next time I install a new mac)

# H1: One-time setups for git

## Global gitattributes file
git config --global core.attributesfile ~/.gitattributes

## Global git aliases
git config --global alias.list-untracked-branches '!git branch --format="%(refname:short) %(upstream)" | awk '"'"'$2 == "" {print $1}'"'"' | while read branch; do echo "$(git show -s --format="%ci %cr" $branch) $branch"; done | sort'
git config --global alias.delete-untracked '!git branch --format="%(refname:short) %(upstream)" | awk '"'"'$2 == "" {print $1}'"'"' | xargs git branch -D'
git config --global alias.list-gone-branches "!git fetch --prune && git branch -vv | grep '\[.*: gone\]'"
git config --global alias.delete-gone-branches "!git fetch --prune && git branch -vv | grep ': gone]' | awk '{print \$1}' | xargs git branch -D"
git config --global alias.delete-branches-select "!git for-each-ref --format=\"%(refname:short)  [%(upstream:short)] %(upstream:track)\" refs/heads | fzf -m | awk '{print \$1}' | xargs -r git branch -d"
git config --global alias.switch-select "!git for-each-ref --format='%(refname:short)  [%(upstream:short)] %(upstream:track)' refs/heads \
  | fzf \
  | awk '{print \$1}' \
  | xargs -r git switch"

