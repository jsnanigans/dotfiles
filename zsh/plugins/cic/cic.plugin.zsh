function cic {
  gh workflow view deploy-aws.yml
}

# _gwe() {
#   # Get a list of local branches (excluding the current one)
#   local -a branches
#   branches=($(git worktree list | awk 'NR>1 {gsub(/.+9am-fe\//, ""); print $1}'))
#
#   # Use _describe for simpler completion matching
#   _describe 'branch' branches
# }

# Tell Zsh to use the _gwe function for gwe completions
# compdef _gwe gwe

# alias gwed="gwe develop"
# alias gwem="gwe main"
# alias gwer="gwe release"
