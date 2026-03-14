function fish_prompt
    set -l normal (set_color normal)
    set -l pwd_color (set_color $fish_color_cwd)
    echo -e -n "$pwd_color$_hydro_pwd$normal $_hydro_status$normal "
end
