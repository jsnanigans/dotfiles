function gwe --description "Switch to a git worktree"
    # Check if a branch name is provided
    if test -z "$argv[1]"
        echo "Usage: gwe <branch_name>"
        return 1
    end

    # Get the bare repository path
    set -l bare_repo (git rev-parse --show-toplevel 2>/dev/null)

    # Check if we are in a git repository
    if test -z "$bare_repo"
        echo "Error: Not a git repository."
        return 1
    end

    # Construct the worktree path
    set -l worktree_path "$bare_repo/../$argv[1]"

    # Check if the worktree exists
    if not test -d "$worktree_path"
        echo "Error: Worktree '$argv[1]' not found."
        return 1
    end

    # Change directory to the worktree
    cd "$worktree_path" && echo "Switched to worktree '$argv[1]'"
end