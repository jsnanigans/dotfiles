function git-stage-interactive --description "Interactive git staging with fzf"
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Not in a git repository" >&2
        return 1
    end

    if not command -q fzf
        echo "fzf is required for this command" >&2
        return 1
    end

    set -l files (git status --porcelain | fzf --multi --preview 'git diff --color=always {2}' \
        --bind 'ctrl-s:execute(git add {2})+reload(git status --porcelain)' \
        --bind 'ctrl-u:execute(git reset HEAD {2})+reload(git status --porcelain)' \
        --bind 'ctrl-d:preview(git diff --color=always {2})' \
        --bind 'ctrl-c:preview(git diff --cached --color=always {2})' \
        --header 'ENTER: select | Ctrl-S: stage | Ctrl-U: unstage | Ctrl-D: diff | Ctrl-C: cached diff' \
        | awk '{print $2}')

    if test -n "$files"
        for file in $files
            git add $file
            echo "Staged: $file"
        end
    end
end