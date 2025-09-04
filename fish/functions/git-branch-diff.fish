function git-branch-diff --description "Show files changed compared to a branch"
    set -l branch $argv[1]
    if test -z "$branch"
        set branch "release"
    end

    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Not in a git repository" >&2
        return 1
    end

    echo "Files changed compared to $branch branch:"
    echo ""

    set -l files (git diff --name-only $branch...HEAD; git diff --name-only; git diff --name-only --cached; git ls-files --others --exclude-standard | sort | uniq)

    if test (count $files) -eq 0
        echo "No changes found"
        return 0
    end

    for file in $files
        set -l file_status ""
        
        if git diff --name-only --cached | grep -q "^$file\$"
            set file_status (set_color green)"✓ Staged"(set_color normal)
        else if git diff --name-only | grep -q "^$file\$"
            set file_status (set_color yellow)"● Modified"(set_color normal)
        else if git ls-files --others --exclude-standard | grep -q "^$file\$"
            set file_status (set_color blue)"? Untracked"(set_color normal)
        else
            set file_status (set_color magenta)"○ Branch diff"(set_color normal)
        end

        printf "%-20s %s\n" "$file_status" "$file"
    end
end