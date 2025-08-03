#!/usr/bin/env fish
# Tmux launcher script for Fish shell
# This script ensures tmux sessions are properly managed

function tmux-launcher --description "Smart tmux session launcher"
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
        # No sessions exist, create a new one
        # Use current directory name as session name if in a project
        set session_name "main"
        if test "$PWD" != "$HOME"
            and test (basename "$PWD") != "/"
            set session_name (basename "$PWD" | tr . _)
        end
        tmux new-session -s $session_name
    else if test (count $sessions) -eq 1
        # One session exists, attach to it
        tmux attach-session -t $sessions[1]
    else
        # Multiple sessions exist, check if we have fzf for better selection
        if command -v fzf &> /dev/null
            set selected (printf '%s\n' $sessions | fzf --height=10 --prompt="Select tmux session: ")
            if test -n "$selected"
                tmux attach-session -t $selected
            else
                # User cancelled fzf
                return 0
            end
        else
            # Fallback to numbered selection
            echo "Available tmux sessions:"
            for i in (seq (count $sessions))
                echo "  $i) $sessions[$i]"
            end
            echo "  n) Create new session"
            echo "  q) Quit"
            
            read -P "Select session: " choice
            
            if test "$choice" = "q"
                return 0
            else if test "$choice" = "n"
                read -P "New session name: " session_name
                if test -z "$session_name"
                    set session_name "session-"(date +%s)
                end
                tmux new-session -s $session_name
            else if string match -qr '^[0-9]+$' -- $choice
                and test $choice -ge 1
                and test $choice -le (count $sessions)
                tmux attach-session -t $sessions[$choice]
            else
                echo "Invalid choice"
                return 1
            end
        end
    end
end

# Export the function for use in other scripts
funcsave tmux-launcher 2>/dev/null

# Run the launcher if called directly
if test (basename (status -f)) = "tmux-launcher.fish"
    tmux-launcher
end