# Only for interactive sessions
status is-interactive; or return

fzf --fish | source
atuin init fish --disable-up-arrow | source
atuin ai init fish | source
zoxide init fish | source
direnv hook fish | source

# Abbreviations
## terminal stuff
abbr -a ll "ls -alh"

## git
## NOTE: native git aliases are set up in: .config/dotfile_setup.sh
abbr -a gs "git status"
abbr -a ga "git add"
abbr -a gc "git commit"
abbr -a gp "git push"
abbr -a gl "git log"
abbr -a gd "git diff"
abbr -a gds "git diff --staged"
abbr -a gr "git restore"
abbr -a gsw "git switch"
abbr -a gmain "git switch main && git pull"

## jj
abbr -a js "jj st"
abbr -a jd "jj diff"

## dotfiles
abbr -a ds "dotfiles status"
abbr -a da "dotfiles add"
abbr -a dc "dotfiles commit"
abbr -a dp "dotfiles push"
abbr -a dl "dotfiles log"
abbr -a dd "dotfiles diff"
abbr -a dds "dotfiles diff --staged"
abbr -a dr "dotfiles restore"

## teleporters
abbr -a telpers "cd ~/workspaces/personal"
abbr -a telwerk "cd ~/workspaces/werk"
abbr -a telpi "cd ~/.pi/agent/"

## configs
abbr -a cfgclaude "nvim ~/.claude/settings.json"
abbr -a cfgpi "cd ~/.pi/agent/ && nve"

## misc
abbr -a cdx-spark "codex -c 'model_reasoning_effort=high' --model gpt-5.3-codex-spark"
abbr -a cdx-xhigh "codex -c 'model_reasoning_effort=xhigh' --model gpt-5.4"
abbr -a oc "opencode"
abbr -a cc "claude"
abbr -a cc-opus "claude --model opus"
abbr -a cc-sonnet "claude --model sonnet"

if test "$PWD" = "$HOME"
    fastfetch
end
