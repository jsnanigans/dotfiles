function git-quick-commit --description "Quick commit with message"
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Not in a git repository" >&2
        return 1
    end

    set -l staged (git diff --name-only --cached)
    if test -z "$staged"
        echo (set_color red)"No files staged for commit"(set_color normal) >&2
        echo ""
        echo "Unstaged changes:"
        git status --short
        echo ""
        echo -n "Stage all changes and commit? [y/N] "
        read -l response
        if test "$response" = "y" -o "$response" = "Y"
            git add -A
            echo "All changes staged"
        else
            return 1
        end
    end

    echo (set_color green)"Files to be committed:"(set_color normal)
    git diff --name-only --cached | sed 's/^/  /'
    echo ""

    if test (count $argv) -gt 0
        set -l message (string join " " $argv)
        git commit -m "$message"
    else
        echo -n "Commit message: "
        read -l message
        if test -z "$message"
            echo "Commit cancelled"
            return 1
        end
        git commit -m "$message"
    end
end