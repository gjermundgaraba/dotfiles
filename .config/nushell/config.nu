# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.

use std/util "path add" # Used to _prepend_ paths to $env.PATH

# Basics
$env.config.show_banner = false
$env.config.buffer_editor = "nvim"
ulimit -n 4096    # Open files

# Aliases
## Git (and dotfiles) aliases
alias dotfiles = /usr/bin/git $"--git-dir=($env.HOME | path join '.cfg')" $"--work-tree=($env.HOME)"
alias ga = git add
alias da = dotfiles add
alias gc = git commit
alias dc = dotfiles commit
alias gp = git push
alias dp = dotfiles push
alias gs = git status
alias ds = dotfiles status
alias gd = git diff
alias dd = dotfiles diff
alias gsw = git switch
alias gsws = git switch-select
def gmain [] {
    git switch main; git pull
}

# NOTE: Git aliases proper are set up as a one-time setup in the script .config/dotfiles_setup.nu

alias configzsh = nvim ~/.zshrc
alias confighammerspoon = nvim ~/.hammerspoon/init.lua
alias confignvim = nvim ~/.config/nvim
alias configghostty = nvim ~/.config/ghostty/config
alias configclaude = nvim ~/.claude/settings.json
alias configglobalgit = nvim ~/.config/.gitignore_global
alias configsketchybar = nvim ~/.config/sketchybar
alias configaerospace = nvim ~/.config/aerospace/aerospace.toml
alias configcodex = nvim ~/.config/codex/config.toml

## Binary aliases
alias tailscale = /Applications/Tailscale.app/Contents/MacOS/Tailscale
alias timeout = gtimeout

## Script aliases
alias setup_rules = ~/.config/ai-rules/scripts/create-symlinks.sh

# AI stuff
def qwarp [...args] {
    let prompt = if ($args | is-empty) {
        input "Enter prompt: "
    } else {
        $args | str join " "
    }
    warp agent run --prompt $prompt
}

# General bin paths
path add "~/bin"
path add "~/.local/bin"

# Application setups
## Go
path add "~/go/bin"
$env.GOPATH = $env.HOME | path join "go"

## Rust not needed, added automatically by something 🤷

## Claude
path add "~/.claude/local"

## Codex
$env.CODEX_HOME = $env.HOME | path join ".config/codex"

## Bun
$env.BUN_INSTALL = $env.HOME | path join ".bun"
path add ($env.BUN_INSTALL | path join "bin")

# Foundry
path add "~/.foundry/bin"

# SP1
path add "~/.sp1/bin"

# Zoxide (z)
source ~/.zoxide.nu

# Carapace
source ~/.cache/carapace/init.nu

# Custom scripts
source ~/.config/nushell/work.nu

# Run neofetch when starting in home directory
if ($env.PWD == $env.HOME) {
    neofetch
}

