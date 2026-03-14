function new-clone --description 'Clone origin into worktree base and switch branch'
    if not set -q argv[1]
        echo "usage: new-clone <branch_name>" >&2
        return 1
    end

    if not set -q WANNABE_WORKTREES_BASE
        echo "WANNABE_WORKTREES_BASE is required" >&2
        return 1
    end

    set -l branch_name $argv[1]
    set -l repo_root (git rev-parse --show-toplevel 2>/dev/null)
    or begin
        echo "current directory must be inside a git repo" >&2
        return 1
    end

    set -l remote_url (git -C $repo_root remote get-url origin 2>/dev/null)
    or begin
        echo "origin remote is required" >&2
        return 1
    end

    set -l repo_name (string replace -r '\.git$' '' -- (path basename -- $remote_url))
    set -l safe_branch (string replace -a / - $branch_name)
    set -l target_dir $WANNABE_WORKTREES_BASE/$repo_name/$safe_branch
    set -l target_exists 0

    mkdir -p (path dirname -- $target_dir)
    or return 1

    if test -d $target_dir
        set target_exists 1
    else
        git clone $remote_url $target_dir
        or return 1
    end

    cd $target_dir
    or return 1

    git switch $branch_name
    or return 1

    if test $target_exists -eq 1
        git pull
        or return 1
    end

    link-agents-md .
end
