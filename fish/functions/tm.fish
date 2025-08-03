function tm --description "Tmux session manager"
    # If no arguments, run the launcher
    if test (count $argv) -eq 0
        source $DOTFILES/tmux/tmux-launcher.fish
        tmux-launcher
        return
    end

    set cmd $argv[1]

    switch $cmd
        case new n
            # Create new session
            if test (count $argv) -gt 1
                set session_name $argv[2]
            else
                read -P "Session name: " session_name
            end
            
            if test -z "$session_name"
                set session_name "session-"(date +%s)
            end
            
            if set -q TMUX
                tmux new-session -d -s $session_name
                tmux switch-client -t $session_name
            else
                tmux new-session -s $session_name
            end

        case kill k
            # Kill session
            if test (count $argv) -gt 1
                tmux kill-session -t $argv[2]
            else
                # Show list of sessions to kill
                set sessions (tmux list-sessions -F "#{session_name}" 2>/dev/null)
                if test (count $sessions) -eq 0
                    echo "No tmux sessions to kill"
                    return 1
                end
                
                echo "Select session to kill:"
                for i in (seq (count $sessions))
                    echo "  $i) $sessions[$i]"
                end
                
                read -P "Choice: " choice
                if string match -qr '^[0-9]+$' -- $choice
                    and test $choice -ge 1
                    and test $choice -le (count $sessions)
                    tmux kill-session -t $sessions[$choice]
                end
            end

        case list ls
            # List sessions
            tmux list-sessions 2>/dev/null || echo "No tmux sessions"

        case attach a
            # Attach to session
            if test (count $argv) -gt 1
                tmux attach-session -t $argv[2]
            else
                source $DOTFILES/tmux/tmux-launcher.fish
                tmux-launcher
            end

        case switch s
            # Switch to session (when already in tmux)
            if not set -q TMUX
                echo "Not in a tmux session"
                return 1
            end
            
            if test (count $argv) -gt 1
                tmux switch-client -t $argv[2]
            else
                # Interactive session switcher
                set sessions (tmux list-sessions -F "#{session_name}" 2>/dev/null)
                echo "Switch to session:"
                for i in (seq (count $sessions))
                    echo "  $i) $sessions[$i]"
                end
                
                read -P "Choice: " choice
                if string match -qr '^[0-9]+$' -- $choice
                    and test $choice -ge 1
                    and test $choice -le (count $sessions)
                    tmux switch-client -t $sessions[$choice]
                end
            end

        case help h '*'
            echo "Tmux session manager"
            echo ""
            echo "Usage: tm [command] [args]"
            echo ""
            echo "Commands:"
            echo "  tm              - Launch tmux (attach or create session)"
            echo "  tm new [name]   - Create new session"
            echo "  tm kill [name]  - Kill session"
            echo "  tm list         - List all sessions"
            echo "  tm attach [name]- Attach to session"
            echo "  tm switch [name]- Switch to session (when in tmux)"
            echo "  tm help         - Show this help"
            echo ""
            echo "Aliases: n=new, k=kill, ls=list, a=attach, s=switch, h=help"
    end
end