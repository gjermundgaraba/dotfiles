function fish_right_prompt
    set -l git_color (set_color $fish_color_comment)
    set -l normal (set_color normal)
    echo -n "$git_color"(__prompt_vcs)"$normal"
end
