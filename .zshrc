## Oh My Zsh (Currentluy disabled)
# Path to your Oh My Zsh installation.
#export ZSH="$HOME/.oh-my-zsh"

### Theme
#ZSH_THEME="robbyrussell"

### Plugins
#plugins=(git)

# source $ZSH/oh-my-zsh.sh

## ZSH stuff
# setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
export HISTSIZE=25000
export SAVEHIST=25000
HISTFILE=~/.zsh_history

## Applications
### Homebrew
eval "$(brew shellenv)"
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

### Starship
eval "$(starship init zsh)"

### fzf
source <(fzf --zsh)

## Aliases
### Git aliases
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gpl="git pull"
alias gs="git status"
alias gd="git diff"
alias gsw="git switch"
alias gsws="git switch-select"

# One-time setups (like git config aliases and similar) are done in .config/dotfile_setup.sh

### Dotfiles (https://www.atlassian.com/git/tutorials/dotfiles)
alias dotfiles='/usr/bin/git --git-dir=/Users/gg/.cfg/ --work-tree=/Users/gg'

### Command line tool replacements
alias ls="lsd"
#alias cat="bat"

### Other aliases
alias c="cd ~/code"
alias gibc="cd ~/code/ibc-go"
alias gsolidity="cd ~/code/solidity-ibc-eureka"
alias gops="cd ~/code/eureka-ops"
alias gsdk="cd ~/code/contrib/cosmos-sdk"
alias ggaia="cd ~/code/contrib/gaia"
alias gwasmd="cd ~/code/contrib/wasmd"
alias glibibc="cd ~/code/libibc"
alias configzsh="nvim ~/.zshrc"
alias confignvim="cd ~/.config/nvim && nvim"
alias configstarship="nvim ~/.config/starship.toml"
alias configghostty="nvim ~/.config/ghostty/config"
alias configaerospace="nvim ~/.config/aerospace/aerospace.toml"
alias ggbrain="cd ~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/gg-brain && nvim"

# NOTE: Git aliases are set up as a one-time setup in the script .config/dotfiles_setup.sh

## Exports
### Go
export PATH=/Users/gg/go/bin:$PATH
export GOPATH=/Users/gg/go

### bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

### Custom
export PATH=/Users/gg/Binaries:$PATH

## Completions
### bun
[ -s "/Users/gg/.bun/_bun" ] && source "/Users/gg/.bun/_bun"

## Startup stuff
if [[ "$PWD" == "$HOME" ]]; then
    neofetch
fi
export PATH=~/.npm-global/bin:$PATH

. "$HOME/.local/bin/env"

## Enable vi mode
bindkey -v
