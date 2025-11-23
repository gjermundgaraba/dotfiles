## ZSH stuff
### History sharing across sessions work
setopt SHARE_HISTORY
export HISTSIZE=25000
export SAVEHIST=25000
HISTFILE=~/.zsh_history
ulimit -n 4096

## Applications
### Homebrew
eval "$(brew shellenv)"
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

### fzf
source <(fzf --zsh)

### Carapace
autoload -Uz compinit
compinit
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
source <(carapace _carapace zsh)

### Load Rust environment
. "$HOME/.cargo/env"

### Zoxide
eval "$(zoxide init zsh)"

## Functions
qwarp() {
  local prompt
  if [ "$#" -eq 0 ]; then
    read -r prompt\?"Enter prompt: "
  else
    prompt="$*"
  fi
  warp agent run --prompt "$prompt"
}

## Aliases

### Git aliases
# NOTE: One-time setups (like git config aliases and similar) are done in .config/dotfile_setup.sh
alias ga="git add"
alias da="dotfiles add"
alias gc="git commit"
alias dc="dotfiles commit"
alias gp="git push"
alias dp="dotfiles push"
alias gs="git status"
alias ds="dotfiles status"
alias gd="git diff"
alias dd="dotfiles diff"
alias gsw="git switch"
alias gmain="git switch main && git pull"

### Dotfiles (https://www.atlassian.com/git/tutorials/dotfiles)
alias dotfiles='/usr/bin/git --git-dir=/Users/gg/.cfg/ --work-tree=/Users/gg'

### Command line tool replacements
alias ls="lsd"
#alias cat="bat"

### Other aliases

#### Misc aliases
alias q="qwarp"
alias setup_rules="ai-rules create-symlinks cursor"
alias timeout="gtimeout"

# NOTE: Git aliases are set up as a one-time setup in the script .config/dotfiles_setup.sh

### Tailscale alias
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

## Exports
### Go
export PATH=/Users/gg/go/bin:$PATH
export GOPATH=/Users/gg/go

### bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/Users/gg/.bun/_bun" ] && source "/Users/gg/.bun/_bun"

### Rust stuff
export PATH="$PATH:/Users/gg/.foundry/bin"
export PATH="$PATH:/Users/gg/.sp1/bin"

### Codex
export CODEX_HOME="$HOME/.config/codex"

### Custom binaries and such
export PATH="${PATH}:/Users/gg/bin"
export PATH="/Users/gg/.local/bin:$PATH"

### Claude
export PATH="$HOME/.claude/local:$PATH"

## Starship
eval "$(starship init zsh)"

## Startup stuff
if [[ "$PWD" == "$HOME" ]]; then
    neofetch
fi

## Source work-specific configuration if present
if [ -f "$HOME/.zshrc-work" ]; then
  source "$HOME/.zshrc-work"
fi



# Added by Antigravity
export PATH="/Users/gg/.antigravity/antigravity/bin:$PATH"
