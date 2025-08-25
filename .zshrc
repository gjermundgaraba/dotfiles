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

## Aliases
### Git aliases
# NOTE: One-time setups (like git config aliases and similar) are done in .config/dotfile_setup.sh
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gpl="git pull"
alias gs="git status"
alias gd="git diff"
alias gsw="git switch"
alias gsws="git switch-select"
alias gmain="git switch main && git pull"

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
alias configdotfilessetup="cd ~/.config && nvim dotfiles_setup.sh"
alias confighammerspoon="nvim ~/.hammerspoon/init.lua"
alias confignvim="cd ~/.config/nvim && nvim"
alias configghostty="nvim ~/.config/ghostty/config"
alias configclaude="nvim ~/.claude/settings.json"
alias ggbrain="cd ~/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/gg-brain && nvim"
alias setup_cursor_rules="$HOME/.config/ai-rules/scripts/create_cursor_symlinks.sh"
alias setup_windsurf_rules="$HOME/.config/ai-rules/scripts/create_windsurf_symlinks.sh"

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

## Enable vi mode
# bindkey -v

export PATH="${PATH}:/Users/gg/bin"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/gg/.lmstudio/bin"
# End of LM Studio CLI section

export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
alias claude="/Users/gg/.claude/local/claude"
export PATH="/Users/gg/.local/bin:$PATH"

# Source work-specific configuration if present
if [ -f "$HOME/.zshrc-work" ]; then
  source "$HOME/.zshrc-work"
fi

