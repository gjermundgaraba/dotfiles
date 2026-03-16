status is-interactive; or exit

set -g __prompt_last_pipestatus 0
set -g async_prompt_inherit_variables __prompt_last_pipestatus fish_prompt_pwd_dir_length CMD_DURATION fish_bind_mode pipestatus SHLVL status

function __prompt_store_pipestatus --on-event fish_postexec
    set -g __prompt_last_pipestatus $pipestatus
end
