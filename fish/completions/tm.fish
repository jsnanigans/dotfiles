# Completions for tm (tmux session manager)

# No command
complete -f -c tm -n __fish_use_subcommand -d "Launch tmux"

# Commands
complete -f -c tm -n __fish_use_subcommand -a new -d "Create new session"
complete -f -c tm -n __fish_use_subcommand -a n -d "Create new session"
complete -f -c tm -n __fish_use_subcommand -a kill -d "Kill session"
complete -f -c tm -n __fish_use_subcommand -a k -d "Kill session"
complete -f -c tm -n __fish_use_subcommand -a list -d "List sessions"
complete -f -c tm -n __fish_use_subcommand -a ls -d "List sessions"
complete -f -c tm -n __fish_use_subcommand -a attach -d "Attach to session"
complete -f -c tm -n __fish_use_subcommand -a a -d "Attach to session"
complete -f -c tm -n __fish_use_subcommand -a switch -d "Switch session"
complete -f -c tm -n __fish_use_subcommand -a s -d "Switch session"
complete -f -c tm -n __fish_use_subcommand -a help -d "Show help"
complete -f -c tm -n __fish_use_subcommand -a h -d "Show help"

# Session name completions for commands that take a session
function __fish_tmux_sessions
    tmux list-sessions -F "#{session_name}" 2>/dev/null
end

complete -f -c tm -n "__fish_seen_subcommand_from kill k attach a switch s" -a "(__fish_tmux_sessions)"