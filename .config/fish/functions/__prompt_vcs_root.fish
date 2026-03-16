function __prompt_vcs_root
    command jj root --ignore-working-copy 2>/dev/null
    or command git rev-parse --show-toplevel 2>/dev/null
end
