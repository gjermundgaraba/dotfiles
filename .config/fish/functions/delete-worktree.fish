function delete-worktree --description 'Delete the current worktree after safety checks'
    if not set -q WANNABE_WORKTREES_BASE
        echo "WANNABE_WORKTREES_BASE is required" >&2
        return 1
    end

    set -l worktree_dir (git rev-parse --show-toplevel 2>/dev/null)
    or begin
        echo "not inside a git repository" >&2
        return 1
    end

    set -l expected_base (path normalize -- $WANNABE_WORKTREES_BASE)
    set -l actual_base (path normalize -- (path dirname -- (path dirname -- $worktree_dir)))

    if test $actual_base != $expected_base
        echo "current directory is not inside $WANNABE_WORKTREES_BASE" >&2
        return 1
    end

    set -l git_status (git -C $worktree_dir status --porcelain)

    if set -q git_status[1]
        echo "there are uncommitted changes in the worktree" >&2
        return 1
    end

    set -l current_branch (git -C $worktree_dir branch --show-current)

    if test -n "$current_branch"
        set -l unpushed (git -C $worktree_dir log --oneline origin/$current_branch..HEAD 2>/dev/null)

        if set -q unpushed[1]
            echo "there are unpushed commits on branch $current_branch" >&2
            return 1
        end
    end

    read -P "Delete worktree: $worktree_dir? [y/N] " -l confirm

    if test "$confirm" != y
        echo "aborted" >&2
        return 1
    end

    cd $expected_base
    or return 1

    trash $worktree_dir
    or return 1

    echo "Deleted $worktree_dir"
end
