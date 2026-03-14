function new-worktree --description 'Clone origin into a new worktree directory and create a branch'
    if not set -q argv[1]
        echo "usage: new-worktree <branch_name>" >&2
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

    if git -C $repo_root show-ref --verify --quiet refs/heads/$branch_name
        echo "branch '$branch_name' already exists locally" >&2
        return 1
    end

    if git -C $repo_root ls-remote --exit-code --heads origin $branch_name >/dev/null 2>&1
        echo "branch '$branch_name' already exists on remote" >&2
        return 1
    end

    set -l repo_name (string replace -r '\.git$' '' -- (path basename -- $remote_url))
    set -l safe_branch (string replace -a / - $branch_name)
    set -l clone_parent $WANNABE_WORKTREES_BASE/$repo_name
    set -l clone_dir $clone_parent/$safe_branch

    mkdir -p $clone_parent
    or return 1

    git clone $remote_url $clone_dir
    or return 1

    cd $clone_dir
    or return 1

    git switch -c $branch_name
    or return 1

    link-agents-md .
end
