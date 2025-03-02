## Oh My Zsh (Currentluy disabled)
# Path to your Oh My Zsh installation.
#export ZSH="$HOME/.oh-my-zsh"

### Theme
#ZSH_THEME="robbyrussell"

### Plugins
#plugins=(git)

# source $ZSH/oh-my-zsh.sh

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
git config --global alias.list-untracked-branches '!git branch --format="%(refname:short) %(upstream)" | awk '"'"'$2 == "" {print $1}'"'"' | while read branch; do echo "$(git show -s --format="%ci %cr" $branch) $branch"; done | sort'
git config --global alias.delete-untracked '!git branch --format="%(refname:short) %(upstream)" | awk '"'"'$2 == "" {print $1}'"'"' | xargs git branch -D'
git config --global alias.list-gone-branches "!git fetch --prune && git branch -vv | grep '\[.*: gone\]'"
git config --global alias.delete-gone-branches "!git fetch --prune && git branch -vv | grep ': gone]' | awk '{print \$1}' | xargs git branch -D"
git config --global alias.delete-branches-select "!git for-each-ref --format=\"%(refname:short)  [%(upstream:short)] %(upstream:track)\" refs/heads | fzf -m | awk '{print \$1}' | xargs -r git branch -d"
git config --global alias.switch-select "!git for-each-ref --format='%(refname:short)  [%(upstream:short)] %(upstream:track)' refs/heads \
  | fzf \
  | awk '{print \$1}' \
  | xargs -r git switch"

#### Just for fun git aliases
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
