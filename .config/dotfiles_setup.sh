#!/bin/bash

# H1: Brew installs
brew install libusb
brew install just
brew install protobuf
brew install neovim
brew install fzf
brew install ripgrep
brew install bat
brew install fd
brew install git-lfs
git lfs install
brew install oven-sh/bun/bun
brew install btop
brew install lazygit
brew install lazydocker
brew install k9s
brew install kubectl
brew install awscli
brew install lsd
brew install neofetch
brew install python
brew install json5

# H1: Mac one-time setups

defaults write -g ApplePressAndHoldEnabled -bool false # This will not be in effect until restarted


# H1: One-time setups for git

## Global gitattributes file
git config --global core.attributesfile ~/.gitattributes

## Global gitignore file
git config --global core.excludesFile ~/.config/.gitignore_global

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

echo "Dotfiles setup complete"
