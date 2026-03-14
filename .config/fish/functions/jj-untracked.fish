function jj-untracked
    set -l tracked (jj bookmark list --tracked -T 'name ++ "\n"')
    set -l remote_branches (git branch -r --format='%(refname:lstrip=3)')

    for b in (jj bookmark list -T 'name ++ "\n"')
        if not contains -- $b $tracked
            if contains -- $b $remote_branches
                echo "untracked (remote exists): $b"
            else
                echo "untracked (local only):    $b"
            end
        end
    end
end
