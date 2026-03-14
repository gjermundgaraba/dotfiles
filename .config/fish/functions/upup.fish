function upup --description 'Update brew, npm, cargo, go, and fisher'
    set -l temp_dir (command mktemp -d)
    or return 1

    set -l overall_status 0

    set -l brew_status skipped
    set -l npm_status skipped
    set -l cargo_status skipped
    set -l go_status skipped
    set -l fisher_status skipped

    set -l brew_applied
    set -l npm_applied
    set -l cargo_applied
    set -l go_applied
    set -l fisher_refreshed

    function __upup_brew_names --no-scope-shadowing
        for line in $argv
            set -l parts (string split -m1 ' ' -- $line)

            if set -q parts[1]; and test -n "$parts[1]"
                echo $parts[1]
            end
        end
    end

    function __upup_cargo_entries --no-scope-shadowing
        for index in (seq 1 2 (count $argv))
            set -l line $argv[$index]

            if string match -qr ' \(/' -- $line
                continue
            end

            set -l fields (string split ' ' -- $line)

            if set -q fields[1]; and set -q fields[2]
                printf "%s\t%s\n" $fields[1] (string replace -r ':$' '' -- $fields[2])
            end
        end
    end

    function __upup_cargo_find_version --no-scope-shadowing
        set -l crate_name $argv[1]

        for entry in $argv[2..-1]
            set -l fields (string split \t -- $entry)

            if test "$fields[1]" = "$crate_name"
                echo $fields[2]
                return 0
            end
        end

        return 1
    end

    echo
    echo "--- brew ---"
    echo

    if command -sq brew
        set brew_status ok
        set -l brew_before (command brew outdated --verbose 2>/dev/null)
        set -l brew_after

        if test $status -ne 0
            set brew_status failed
            set overall_status 1
        end

        if test $brew_status = ok
            set -l brew_before_names (__upup_brew_names $brew_before)

            for step in update upgrade cleanup doctor
                echo "\$ brew $step"
                command brew $step

                if test $status -ne 0
                    set brew_status failed
                    set overall_status 1
                    break
                end

                echo
            end

            if test $brew_status = ok
                set brew_after (command brew outdated --verbose 2>/dev/null)

                if test $status -eq 0
                    set -l brew_after_names (__upup_brew_names $brew_after)

                    for line in $brew_before
                        set -l name (string split -m1 ' ' -- $line)[1]

                        if test -n "$name"; and not contains -- $name $brew_after_names
                            set --append brew_applied $line
                        end
                    end
                end
            end
        end
    else
        echo "brew not found"
    end

    echo
    echo "--- npm ---"
    echo

    if command -sq npm
        set npm_status ok
        set -l npm_before $temp_dir/npm-before.json
        set -l npm_after $temp_dir/npm-after.json

        command npm list -g --depth=0 --json >$npm_before 2>/dev/null

        if test $status -ne 0
            set npm_status failed
            set overall_status 1
        end

        if test $npm_status = ok
            echo "\$ npm update -g"
            command npm update -g

            if test $status -ne 0
                set npm_status failed
                set overall_status 1
            else
                command npm list -g --depth=0 --json >$npm_after 2>/dev/null

                if test $status -eq 0
                    set npm_applied (
                        command jq -rn \
                            --slurpfile before $npm_before \
                            --slurpfile after $npm_after '
def deps($doc):
  ($doc[0].dependencies // {})
  | with_entries(.value = (.value.version // "unknown"));

(deps($before)) as $before_deps
| (deps($after)) as $after_deps
| ($after_deps | keys | .[]) as $name
| if ($before_deps[$name] // null) == null then
    "\($name): installed \($after_deps[$name])"
  elif $before_deps[$name] != $after_deps[$name] then
    "\($name): \($before_deps[$name]) -> \($after_deps[$name])"
  else
    empty
  end
'
                    )
                end

                echo
                echo "\$ npm outdated -g"
                command npm outdated -g

                if test $status -eq 0
                    echo "No outdated npm packages"
                end
            end
        end
    else
        echo "npm not found"
    end

    echo
    echo "--- cargo ---"
    echo

    if command -sq cargo
        set cargo_status ok
        set -l crates
        set -l cargo_list (command cargo install --list)
        set -l cargo_before
        set -l cargo_after

        if test $status -ne 0
            set cargo_status failed
            set overall_status 1
        else
            set cargo_before (__upup_cargo_entries $cargo_list)

            for entry in $cargo_before
                set --append crates (string split \t -- $entry)[1]
            end
        end

        if test $cargo_status = ok; and not set -q crates[1]
            echo "No non-local cargo installs found."
        else if test $cargo_status = ok
            echo "\$ cargo install --locked ..."
            command cargo install --locked $crates

            if test $status -ne 0
                set cargo_status failed
                set overall_status 1
            else
                set cargo_after (__upup_cargo_entries (command cargo install --list))

                if test $status -eq 0
                    for after_entry in $cargo_after
                        set -l after_fields (string split \t -- $after_entry)
                        set -l crate_name $after_fields[1]
                        set -l after_version $after_fields[2]
                        set -l before_version (__upup_cargo_find_version $crate_name $cargo_before)

                        if not set -q before_version[1]
                            set --append cargo_applied "$crate_name: installed $after_version"
                            continue
                        end

                        if test "$before_version" != "$after_version"
                            set --append cargo_applied "$crate_name: $before_version -> $after_version"
                        end
                    end
                end

                if test $cargo_status = ok
                    echo

                    if set -q cargo_applied[1]
                        echo "Updated "(count $cargo_applied)" cargo tool(s)"
                    else
                        echo "All cargo tools are up to date"
                    end
                end
            end
        end
    else
        echo "cargo not found"
    end

    echo
    echo "--- go ---"
    echo

    if command -sq go
        set go_status ok
        set -l go_tools_dir $HOME/.config/go-tools
        set -l go_before
        set -l go_after

        if not test -f $go_tools_dir/go.mod
            echo "$go_tools_dir/go.mod not found" >&2
            set go_status failed
            set overall_status 1
        else
            set go_before (command go -C $go_tools_dir list -f '{{.ImportPath}} {{if .Module}}{{.Module.Version}}{{else}}unknown{{end}}' tool 2>/dev/null)

            if test $status -ne 0
                set go_status failed
                set overall_status 1
            else
                echo "\$ go -C $go_tools_dir get -u tool"
                command go -C $go_tools_dir get -u tool

                if test $status -ne 0
                    set go_status failed
                    set overall_status 1
                else
                    echo
                    echo "\$ go -C $go_tools_dir install tool"
                    command go -C $go_tools_dir install tool

                    if test $status -ne 0
                        set go_status failed
                        set overall_status 1
                    else
                        set go_after (command go -C $go_tools_dir list -f '{{.ImportPath}} {{if .Module}}{{.Module.Version}}{{else}}unknown{{end}}' tool 2>/dev/null)

                        if test $status -ne 0
                            set go_status failed
                            set overall_status 1
                        else
                            for after_entry in $go_after
                                set -l after_fields (string split ' ' -- $after_entry)
                                set -l tool_path $after_fields[1]
                                set -l after_version $after_fields[2]
                                set -l before_version

                                for before_entry in $go_before
                                    set -l before_fields (string split ' ' -- $before_entry)

                                    if test "$before_fields[1]" = "$tool_path"
                                        set before_version $before_fields[2]
                                        break
                                    end
                                end

                                if not set -q before_version[1]
                                    set --append go_applied "$tool_path: installed $after_version"
                                else if test "$before_version" != "$after_version"
                                    set --append go_applied "$tool_path: $before_version -> $after_version"
                                end
                            end

                            echo
                        end
                    end
                end
            end
        end

        if test $go_status = ok
            if set -q go_applied[1]
                echo "Updated "(count $go_applied)" Go tool(s)"
            else
                echo "All Go tools are up to date"
            end
        end
    else
        echo "go not found"
    end

    echo
    echo "--- fisher ---"
    echo

    if functions -q fisher
        set fisher_status ok
        set fisher_refreshed (fisher list 2>/dev/null)

        echo "\$ fisher update"
        fisher update

        if test $status -ne 0
            set fisher_status failed
            set overall_status 1
            set fisher_refreshed
        end
    else
        echo "fisher not found"
    end

    echo
    echo "--- upup done ---"
    echo
    echo "Summary:"
    echo "  brew:   $brew_status"
    echo "  npm:    $npm_status"
    echo "  cargo:  $cargo_status"
    echo "  go:     $go_status"
    echo "  fisher: $fisher_status"

    if set -q brew_applied[1]
        echo
        echo "Applied brew updates:"

        for item in $brew_applied
            echo "  $item"
        end
    end

    if set -q npm_applied[1]
        echo
        echo "Applied npm updates:"

        for item in $npm_applied
            echo "  $item"
        end
    end

    if set -q cargo_applied[1]
        echo
        echo "Applied cargo updates:"

        for item in $cargo_applied
            echo "  $item"
        end
    end

    if set -q go_applied[1]
        echo
        echo "Applied Go updates:"

        for item in $go_applied
            echo "  $item"
        end
    end

    if test $fisher_status = ok; and set -q fisher_refreshed[1]
        echo
        echo "Refreshed fisher plugins:"

        for item in $fisher_refreshed
            echo "  $item"
        end
    end

    command rm -rf $temp_dir
    functions --erase __upup_brew_names __upup_cargo_entries __upup_cargo_find_version

    return $overall_status
end
