# Completion for gwe command
complete -c gwe -f -a '(git worktree list | awk "NR>1 {gsub(/.+9am-fe\//, \"\"); print \$1}")'