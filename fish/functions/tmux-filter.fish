function tmux-filter --description "Filter and sort tmux entities"
    set -l cmd $argv[1]
    
    switch $cmd
        case active
            # Show only sessions with activity
            tmux list-sessions -F "#{?session_activity,#{session_name} (activity),}" | \
            grep -v '^$' | \
            fzf --reverse --header 'Sessions with activity'

        case attached
            # Show attached sessions
            tmux list-sessions -F "#{?session_attached,#{session_name} (attached),}" | \
            grep -v '^$'

        case detached
            # Show detached sessions
            tmux list-sessions -F "#{?session_attached,,#{session_name}}" | \
            grep -v '^$' | \
            fzf --reverse --header 'Detached sessions' | \
            xargs tmux attach-session -t

        case empty
            # Find windows with no active processes
            for session in (tmux list-sessions -F "#{session_name}")
                for window in (tmux list-windows -t $session -F "#I:#W")
                    set -l pane_count (tmux list-panes -t "$session:$window" -F "#{pane_id}" | wc -l)
                    if test $pane_count -eq 1
                        set -l cmd (tmux list-panes -t "$session:$window" -F "#{pane_current_command}")
                        if test "$cmd" = "fish" -o "$cmd" = "bash" -o "$cmd" = "zsh"
                            echo "$session:$window (idle)"
                        end
                    end
                end
            end

        case large
            # Find panes with lots of output
            tmux list-panes -a -F "#S:#I.#P #{history_size}" | \
            sort -k2 -nr | \
            head -20 | \
            fzf --reverse --header 'Panes with most history' | \
            cut -d' ' -f1 | \
            xargs tmux switch-client -t

        case recent
            # Sort sessions by last activity
            tmux list-sessions -F "#{session_activity}:#{session_name}" | \
            sort -rn | \
            cut -d: -f2 | \
            fzf --reverse --header 'Sessions by recent activity' | \
            xargs tmux switch-client -t

        case name
            # Sort sessions alphabetically
            tmux list-sessions -F "#{session_name}" | \
            sort | \
            fzf --reverse --header 'Sessions sorted by name' | \
            xargs tmux switch-client -t

        case size
            # Sort windows by number of panes
            for session in (tmux list-sessions -F "#{session_name}")
                for window in (tmux list-windows -t $session -F "#I:#W")
                    set -l pane_count (tmux list-panes -t "$session:$window" | wc -l)
                    echo "$pane_count panes: $session:$window"
                end
            end | \
            sort -rn | \
            fzf --reverse --header 'Windows by pane count' | \
            sed 's/.*: //' | \
            xargs tmux switch-client -t

        case '*'
            echo "tmux-filter: Filter and sort tmux entities"
            echo ""
            echo "Usage: tmux-filter <command>"
            echo ""
            echo "Commands:"
            echo "  active    - Show sessions with activity"
            echo "  attached  - Show attached sessions"
            echo "  detached  - Show detached sessions"
            echo "  empty     - Find idle windows"
            echo "  large     - Find panes with most history"
            echo "  recent    - Sort sessions by activity"
            echo "  name      - Sort sessions by name"
            echo "  size      - Sort windows by pane count"
    end
end