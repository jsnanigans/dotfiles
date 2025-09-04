function git-hunks --description "Show all git hunks with staging status"
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Not in a git repository" >&2
        return 1
    end

    echo "Git hunks in repository:"
    echo ""

    set -l has_unstaged (git diff --numstat | head -n1)
    set -l has_staged (git diff --cached --numstat | head -n1)

    if test -z "$has_unstaged" -a -z "$has_staged"
        echo "No hunks found"
        return 0
    end

    if test -n "$has_unstaged"
        echo (set_color yellow)"=== Unstaged Hunks ==="(set_color normal)
        git diff --stat
        echo ""
    end

    if test -n "$has_staged"
        echo (set_color green)"=== Staged Hunks ==="(set_color normal)
        git diff --cached --stat
        echo ""
    end

    echo "Use 'git diff' to see unstaged changes"
    echo "Use 'git diff --cached' to see staged changes"
    echo "Use 'git add -p' for interactive staging"
end