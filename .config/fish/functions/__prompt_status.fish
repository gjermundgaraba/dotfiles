function __prompt_status
    set -l normal (set_color normal)
    set -l error_color (set_color $fish_color_error)
    set -l exit_statuses $pipestatus

    if set -q __prompt_last_pipestatus
        set exit_statuses $__prompt_last_pipestatus
    else if set -q __async_prompt_last_pipestatus
        set exit_statuses $__async_prompt_last_pipestatus
    end

    for code in $exit_statuses
        if test $code -ne 0
            echo -n "$error_color| "(string join " " $exit_statuses)" $error_color❱$normal"
            return
        end
    end

    echo -n "❱"
end
