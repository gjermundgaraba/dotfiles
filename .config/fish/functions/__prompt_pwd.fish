function __prompt_pwd
    set -l vcs_root (__prompt_vcs_root)
    set -l vcs_base (string replace --all --regex -- "^.*/" "" "$vcs_root")
    set -l path_sep /
    set -l dir_length (string replace --regex --all -- '^$' 1 "$fish_prompt_pwd_dir_length")

    if test "$fish_prompt_pwd_dir_length" = 0
        set path_sep
    end

    string replace --ignore-case -- ~ \~ $PWD |
        string replace -- "/$vcs_base/" /:/ |
        string replace --regex --all -- "(\.?[^/]{$dir_length})[^/]*/" "\$1$path_sep" |
        string replace -- : "$vcs_base" |
        string replace --regex -- '([^/]+)$' "\x1b[1m\$1\x1b[22m" |
        string replace --regex --all -- '(?!^/$)/|^$' "\x1b[2m/\x1b[22m"
end
