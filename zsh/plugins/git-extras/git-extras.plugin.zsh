function gwe {
  # Check if a branch name is provided
  if [[ -z "$1" ]]; then
    echo "Usage: gwe <branch_name>"
    return 1
  fi

  # Get the bare repository path
  local bare_repo=$(git rev-parse --show-toplevel 2>/dev/null)

  # Check if we are in a git repository
  if [[ -z "$bare_repo" ]]; then
    echo "Error: Not a git repository."
    return 1
  fi

  # Construct the worktree path
  local worktree_path="$bare_repo/../$1"

  # Check if the worktree exists
  if [[ ! -d "$worktree_path" ]]; then
    echo "Error: Worktree '$1' not found."
    return 1
  fi

  # Change directory to the worktree
  cd "$worktree_path" && echo "Switched to worktree '$1'"
}

_gwe() {
  # Get a list of local branches (excluding the current one)
  local -a branches
  branches=($(git worktree list | awk 'NR>1 {gsub(/.+9am-fe\//, ""); print $1}'))

  # Use _describe for simpler completion matching
  _describe 'branch' branches
}

# Tell Zsh to use the _gwe function for gwe completions
compdef _gwe gwe

alias gwed="gwe develop"
alias gwem="gwe main"
alias gwer="gwe release"
