## Oh My Zsh (Currentluy disabled)
# Path to your Oh My Zsh installation.
#export ZSH="$HOME/.oh-my-zsh"

### Theme
#ZSH_THEME="robbyrussell"

### Plugins
#plugins=(git)

# source $ZSH/oh-my-zsh.sh

## Evals
### Homebrew
eval "$(brew shellenv)"
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

### Starship
eval "$(starship init zsh)"

## Aliases
### Git aliases
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gpl="git pull"
alias gs="git status"
alias gd="git diff"
alias hawk="git"
git config --global alias.tuah push
alias leeeroy="git" 
git config --global alias.jenkins push

### Dotfiles (https://www.atlassian.com/git/tutorials/dotfiles)
alias dotfiles='/usr/bin/git --git-dir=/Users/gg/.cfg/ --work-tree=/Users/gg'

### Command line tool replacements
alias ls="lsd"
alias cat="bat"

### Other aliases
alias c="cd ~/code"
alias gibc="cd ~/code/ibc-go"
alias gsolidity="cd ~/code/solidity-ibc-eureka"
alias configzsh="nvim ~/.zshrc"
alias confignvim="cd ~/.config/nvim && nvim"
alias configstarship="nvim ~/.config/starship.toml"
alias configghostty="nvim ~/.config/ghostty/config"
alias configaerospace="nvim ~/.config/aerospace/aerospace.toml"
alias ggbrain="cd ~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/gg-brain && nvim"

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
