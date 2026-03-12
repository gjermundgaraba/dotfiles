#!/bin/bash

brew update

# H1: Brew installs
brew install --quiet libusb
brew install --quiet just
brew install --quiet protobuf
brew install --quiet bufbuild/buf/buf
brew install --quiet git-lfs
git lfs install
brew install --quiet python
brew install --quiet coreutils
brew install --quiet findutils
brew install --quiet gnu-sed
brew install --quiet gawk
brew install --quiet grep
brew install --quiet make
## H2: Applications
brew install --quiet neovim
brew install --quiet fzf
brew install --quiet ripgrep
brew install --quiet bat
brew install --quiet fd
brew install --quiet oven-sh/bun/bun
brew install --quiet btop
brew install --quiet lazygit
brew install --quiet lazydocker
brew install --quiet k9s
brew install --quiet kubectl
brew install --quiet awscli
brew install --quiet --cask aws-vault
brew install --quiet argocd
brew tap hashicorp/tap
brew install --quiet hashicorp/tap/terraform
brew install --quiet lsd
brew install --quiet fastfetch
brew install --quiet golangci-lint
brew install --quiet grpcurl
brew install --quiet zoxide

# H1: Mac one-time setups

defaults write -g ApplePressAndHoldEnabled -bool false # This will not be in effect until restarted
defaults write -g NSWindowShouldDragOnGesture -bool true

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
