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

### mise
eval "$(mise activate zsh)"

### fzf
source <(fzf --zsh)

### Carapace (not sure if using anymore)
# autoload -Uz compinit
# compinit
# export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
# source <(carapace _carapace zsh)

### Load Rust environment
. "$HOME/.cargo/env"

### Zoxide
eval "$(zoxide init zsh)"


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
alias gds="git diff --staged"
alias dd="dotfiles diff"
alias gsw="git switch"
alias gmain="git switch main && git pull"

alias js="jj status"
alias jd="jj diff"

# NOTE: Full-on git aliases are set up as a one-time setup in the script .config/dotfiles_setup.sh

### Teleport alias
#### Personal teleports
alias telpers="cd ~/workspaces/personal"
alias telpi="cd ~/.pi/agent/"

#### Work teleports
alias telwerk="cd ~/workspaces/werk"

### Dotfiles (https://www.atlassian.com/git/tutorials/dotfiles)
# Moved to atuin
#alias dotfiles='/usr/bin/git --git-dir=/Users/gg/.cfg/ --work-tree=/Users/gg'

### Command line tool replacements
alias ll="ls -la"

### Other aliases

#### Misc aliases
# alias timeout="gtimeout"
# alias sed="gsed"
# alias awk="gawk"
# alias make="gmake"
# alias find="gfind"
# alias date="gdate"
# alias grep="ggrep"

alias cdx-spark="codex -c 'model_reasoning_effort=high' --model gpt-5.3-codex-spark"
alias cdx-xhigh="codex -c 'model_reasoning_effort=xhigh' --model gpt-5.4"
alias cfgclaude="nvim ~/.claude/settings.json"
alias cfgpi="cd ~/.pi/agent/ && nve"

alias oc="opencode"

alias cc="claude"
alias cc-opus="claude --model=opus"
alias cc-sonnet="claude --model=sonnet"

alias upup="$HOME/.config/scripts/upup.zsh"

### Tailscale alias
# alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

## Exports
### Editor
export EDITOR="nvim"

### Go
export PATH=/Users/gg/go/bin:$PATH
export GOPATH=/Users/gg/go

### bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/Users/gg/.bun/_bun" ] && source "/Users/gg/.bun/_bun"

### Rust stuff
export PATH="$PATH:/Users/gg/.config/.foundry/bin"
export PATH="$PATH:/Users/gg/.sp1/bin"

### Custom binaries and such
export PATH="${PATH}:/Users/gg/bin"
export PATH="/Users/gg/.local/bin:$PATH"
export PATH="$HOME/.config/scripts:$PATH"

## Starship
eval "$(starship init zsh)"

## Startup stuff
if [[ "$PWD" == "$HOME" ]]; then
    fastfetch
fi

## Source work-specific configuration if present
if [ -f "$HOME/.zshrc-work" ]; then
  source "$HOME/.zshrc-work"
fi

# Depot and platform stuff:
# export GOCACHEPROG="depot gocache"
# export FORCE_DEPOT=1


# Added by Antigravity
export PATH="/Users/gg/.antigravity/antigravity/bin:$PATH"

# Amp CLI
export PATH="/Users/gg/.amp/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/gg/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/gg/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/gg/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/gg/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Source script aliases
source "$HOME/.config/scripts/alias.sh"

# Completion system (must be before any compdef calls)
autoload -Uz compinit && compinit

#compdef opencode
###-begin-opencode-completions-###
#
# yargs command completion script
#
# Installation: opencode completion >> ~/.zshrc
#    or opencode completion >> ~/.zprofile on OSX.
#
_opencode_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" opencode --get-yargs-completions "${words[@]}"))
  IFS=$si
  if [[ ${#reply} -gt 0 ]]; then
    _describe 'values' reply
  else
    _default
  fi
}
if [[ "'${zsh_eval_context[-1]}" == "loadautofunc" ]]; then
  _opencode_yargs_completions "$@"
else
  compdef _opencode_yargs_completions opencode
fi
###-end-opencode-completions-###

# ### Silence F13-F20 (prevent raw escape sequences from printing)
# ### NOTE: Must be at the end of .zshrc, after all source/eval commands
# ### that might reset the keymap.
# bindkey '\e[25~' undefined-key  # F13
# bindkey '\e[26~' undefined-key  # F14
# bindkey '\e[28~' undefined-key  # F15
# bindkey '\e[29~' undefined-key  # F16
# bindkey '\e[31~' undefined-key  # F17
# bindkey '\e[32~' undefined-key  # F18
# bindkey '\e[33~' undefined-key  # F19
# bindkey '\e[34~' undefined-key  # F20

. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh --disable-up-arrow)"

# Entire CLI shell completion
source <(entire completion zsh)

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/gg/.lmstudio/bin"
# End of LM Studio CLI section

# Platform devnet - override KUBECONFIG when in aws-vault session
  if [[ "$AWS_VAULT" == "platform-dev" ]]; then
    export KUBECONFIG="$HOME/.kube/platform-dev.kubeconfig"
    alias cnm="/Users/gg/code/platform/apps/cli/bin/platform"
  fi

eval "$(direnv hook zsh)"

