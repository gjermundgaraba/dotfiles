function resolve-all-pr-comments --description 'Resolve all unresolved PR review threads for the current branch'
    set -l pr_number (gh pr view --json number -q '.number' 2>/dev/null)

    if not set -q pr_number[1]
        echo "no PR found for current branch" >&2
        return 1
    end

    set -l owner (gh repo view --json owner -q '.owner.login' 2>/dev/null)
    set -l repo (gh repo view --json name -q '.name' 2>/dev/null)

    if not set -q owner[1]; or not set -q repo[1]
        echo "could not determine current repository" >&2
        return 1
    end

    echo "Fetching unresolved threads for PR #$pr_number..."

    set -l thread_ids (
        gh api graphql \
            -f query='
                query($owner: String!, $repo: String!, $pr: Int!) {
                  repository(owner: $owner, name: $repo) {
                    pullRequest(number: $pr) {
                      reviewThreads(first: 100) {
                        nodes {
                          id
                          isResolved
                        }
                      }
                    }
                  }
                }
            ' \
            -f owner="$owner" \
            -f repo="$repo" \
            -F pr="$pr_number" \
            --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false) | .id' \
            2>/dev/null
    )

    if not set -q thread_ids[1]
        echo "No unresolved comments found."
        return 0
    end

    set -l count (count $thread_ids)
    echo "Found $count unresolved thread(s). Resolving..."

    set -l resolved 0
    set -l failed 0

    for thread_id in $thread_ids
        if gh api graphql -f query="mutation { resolveReviewThread(input: {threadId: \"$thread_id\"}) { thread { isResolved } } }" >/dev/null 2>&1
            set resolved (math $resolved + 1)
        else
            echo "Failed to resolve thread: $thread_id" >&2
            set failed (math $failed + 1)
        end
    end

    echo "Done. Resolved $resolved thread(s)."

    if test $failed -gt 0
        echo "Failed to resolve $failed thread(s)." >&2
        return 1
    end
end
