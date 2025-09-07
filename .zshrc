## ZSH stuff
### History sharing across sessions work
setopt SHARE_HISTORY
export HISTSIZE=25000
export SAVEHIST=25000
HISTFILE=~/.zsh_history

## Applications
### Homebrew
eval "$(brew shellenv)"
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

### fzf
source <(fzf --zsh)

### Load Rust environment
. "$HOME/.cargo/env"

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
alias gsws="git switch-select"
alias gmain="git switch main && git pull"

### Dotfiles (https://www.atlassian.com/git/tutorials/dotfiles)
alias dotfiles='/usr/bin/git --git-dir=/Users/gg/.cfg/ --work-tree=/Users/gg'

### Command line tool replacements
alias ls="lsd"
#alias cat="bat"

### Other aliases
#### cd aliases
alias c="cd ~/code"
alias gibc="cd ~/code/ibc-go"
alias gmanifests="cd ~/code/ibc-manifests"
alias gsolidity="cd ~/code/solidity-ibc-eureka"
alias gops="cd ~/code/eureka-ops"
alias gsdk="cd ~/code/contrib/cosmos-sdk"
alias ggaia="cd ~/code/contrib/gaia"
alias gwasmd="cd ~/code/contrib/wasmd"
alias glibibc="cd ~/code/libibc"

#### Config aliases
alias configzsh="nvim ~/.zshrc"
alias configdotfilessetup="nvim ~/.config/dotfiles_setup.sh"
alias confighammerspoon="nvim ~/.hammerspoon/init.lua"
alias confignvim="cd ~/.config/nvim && nvim"
alias configghostty="nvim ~/.config/ghostty/config"
alias configclaude="nvim ~/.claude/settings.json"
alias configglobalgit="nvim ~/.config/.gitignore_global"
alias configsketchybar="cd ~/.config/sketchybar && nvim"
alias configaerospace="nvim ~/.config/aerospace/aerospace.toml"

#### Misc aliases
alias setup_rules="$HOME/.config/ai-rules/scripts/create-symlinks.sh"
alias timeout="gtimeout"

#### Claude
alias claude="/Users/gg/.claude/local/claude"

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

### npm, nvm
export PATH=~/.npm-global/bin:$PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

### Rust stuff
export PATH="$PATH:/Users/gg/.foundry/bin"
export PATH="$PATH:/Users/gg/.sp1/bin"

### Solana
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

### Codex
export CODEX_HOME="$HOME/.config/codex"

### Custom binaries and such
export PATH=/Users/gg/Binaries:$PATH
export PATH="${PATH}:/Users/gg/bin"
export PATH="/Users/gg/.local/bin:$PATH"

## Startup stuff
if [[ "$PWD" == "$HOME" ]]; then
    neofetch
fi

## Source work-specific configuration if present
if [ -f "$HOME/.zshrc-work" ]; then
  source "$HOME/.zshrc-work"
fi


