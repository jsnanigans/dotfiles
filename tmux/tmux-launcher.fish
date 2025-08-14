#!/usr/bin/env fish
# Tmux launcher script for Fish shell
# This script ensures tmux sessions are properly managed

function tmux-launcher --description "Smart tmux session launcher (legacy)"
    # Load the unified session manager
    source $DOTFILES/fish/functions/session.fish
    source $DOTFILES/fish/conf.d/projects.fish
    
    # Check if we're already in tmux
    if set -q TMUX
        return 0
    end

    # Check if tmux is installed
    if not command -v tmux &> /dev/null
        echo "tmux is not installed"
        return 1
    end

    # Check if we should skip tmux (e.g., in VS Code terminal)
    if test "$TERM_PROGRAM" = "vscode"
        return 0
    end

    # Get list of existing sessions
    set sessions (tmux list-sessions -F "#{session_name}" 2>/dev/null)

    if test (count $sessions) -eq 0
        # No sessions exist, check if we're in a project
        set -l project (current_project)
        if test -n "$project"
            # Create session for current project
            set session_name (project_name_from_path "$project")
            tmux new-session -s $session_name -c "$project"
        else
            # Create default session
            tmux new-session -s main
        end
    else if test (count $sessions) -eq 1
        # One session exists, attach to it
        tmux attach-session -t $sessions[1]
    else
        # Multiple sessions exist, use unified session attach
        session attach
    end
end

# Export the function for use in other scripts
funcsave tmux-launcher 2>/dev/null

# Run the launcher if called directly
if test (basename (status -f)) = "tmux-launcher.fish"
    tmux-launcher
end