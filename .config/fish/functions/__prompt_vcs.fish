function __prompt_vcs
    if command jj root --ignore-working-copy >/dev/null 2>/dev/null
        __prompt_vcs_jj
        return
    end

    if command git rev-parse --show-toplevel >/dev/null 2>/dev/null
        __prompt_vcs_git
    end
end

function __prompt_vcs_jj
    set -l branch (
        command jj log --ignore-working-copy --no-graph -r 'heads(::@ & bookmarks())' -T '
            local_bookmarks.map(|b| b.name()).join(" ")
        ' 2>/dev/null |
            string trim |
            string split \n |
            string join ' '
    )

    if test -z "$branch"
        set branch (
            command jj log --ignore-working-copy --no-graph -r @ -T '
                "@" ++ change_id.shortest()
            ' 2>/dev/null |
                string trim
        )
    end

    set -l info (
        command jj log --ignore-working-copy --no-graph -r @ -T '
            if(empty && !conflict, "", "•")
        ' 2>/dev/null |
            string trim
    )

    set -l upstream (
        command jj log --ignore-working-copy --no-graph -r 'heads(::@ & bookmarks())' -T '
            local_bookmarks
                .filter(|b| !b.synced())
                .map(|b|
                    separate(
                        " ",
                        if(
                            !b.tracking_ahead_count().zero(),
                            "↑" ++ if(
                                b.tracking_ahead_count().exact(),
                                stringify(b.tracking_ahead_count().exact()),
                                stringify(b.tracking_ahead_count().lower()) ++ "+"
                            )
                        ),
                        if(
                            !b.tracking_behind_count().zero(),
                            "↓" ++ if(
                                b.tracking_behind_count().exact(),
                                stringify(b.tracking_behind_count().exact()),
                                stringify(b.tracking_behind_count().lower()) ++ "+"
                            )
                        )
                    )
                )
                .join(" ")
        ' 2>/dev/null |
            string trim |
            string split \n |
            string join ' '
    )

    echo -n "$branch$info"
    test -n "$upstream" && echo -n " $upstream"
end

function __prompt_vcs_git
    set -l branch (
        command git branch --show-current 2>/dev/null ||
        command git describe --tags --exact-match HEAD 2>/dev/null ||
        command git rev-parse --short HEAD 2>/dev/null |
            string replace --regex -- '(.+)' '@$1'
    )

    set -l dirty
    command git diff-index --quiet HEAD 2>/dev/null
    if test $status -ne 0
        set dirty "•"
    else if test (count (command git ls-files --others --exclude-standard 2>/dev/null)) -gt 0
        set dirty "•"
    end

    set -l behind
    set -l ahead
    command git rev-list --count --left-right @{upstream}...@ 2>/dev/null | read behind ahead

    set -l upstream
    switch "$behind $ahead"
        case " " "0 0"
        case "0 *"
            set upstream " ↑$ahead"
        case "* 0"
            set upstream " ↓$behind"
        case \*
            set upstream " ↑$ahead ↓$behind"
    end

    echo -n "$branch$dirty$upstream"
end
