function relpath --description 'Print a path relative to the current directory'
    if not set -q argv[1]; or set -q argv[2]
        echo "usage: relpath <path>" >&2
        return 1
    end

    set -l base_parts (string split / -- (path resolve -- .))
    set -l target_parts (string split / -- (path resolve -- $argv[1]))
    set -l shared 0
    set -l max_shared (math "min("(count $base_parts)", "(count $target_parts)")")

    while test $shared -lt $max_shared
        set -l next_index (math $shared + 1)

        if test "$base_parts[$next_index]" != "$target_parts[$next_index]"
            break
        end

        set shared $next_index
    end

    set -l result_parts

    for base_part in $base_parts[(math $shared + 1)..-1]
        set --append result_parts ..
    end

    for part in $target_parts[(math $shared + 1)..-1]
        set --append result_parts $part
    end

    if set -q result_parts[1]
        string join / -- $result_parts
    else
        echo .
    end
end
