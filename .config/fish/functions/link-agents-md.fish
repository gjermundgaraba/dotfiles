function link-agents-md --description 'Create CLAUDE.md symlinks next to AGENTS.md files'
    if not set -q argv[1]
        echo "usage: link-agents-md <path>" >&2
        echo "recursively finds AGENTS.md files and creates CLAUDE.md symlinks" >&2
        return 1
    end

    set -l target_path $argv[1]
    set -l resolved_path (path resolve -- $target_path)

    if not path is -d $resolved_path
        echo "'$target_path' does not exist" >&2
        return 1
    end

    for claude_link in (find $resolved_path -type l -name CLAUDE.md 2>/dev/null)
        rm $claude_link
        or return 1

        echo "Removed: $claude_link"
    end

    set -l count 0

    for agents_file in (find $resolved_path -type f -name AGENTS.md 2>/dev/null)
        set -l dir (path dirname -- $agents_file)
        set -l claude_file $dir/CLAUDE.md

        if test -e $claude_file
            echo "Skipping: $claude_file (non-symlink file exists)"
            continue
        end

        ln -s AGENTS.md $claude_file
        or return 1

        echo "Created: $claude_file -> AGENTS.md"
        set count (math $count + 1)
    end

    echo
    echo "Done. Created $count symlink(s)."
end
