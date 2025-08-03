function tmux-search --description "Advanced tmux search and filter functions"
    set -l cmd $argv[1]
    
    switch $cmd
        case sessions sess
            # Search and filter sessions with preview
            tmux list-sessions -F "#{session_name}:#{session_windows} windows#{?session_attached, (attached),}" 2>/dev/null | \
            fzf --reverse \
                --header 'Search tmux sessions' \
                --preview 'tmux list-windows -t {1} -F "#I:#W" 2>/dev/null | head -20' \
                --preview-window=right:40% | \
            cut -d: -f1 | \
            xargs -I{} tmux switch-client -t {} 2>/dev/null || tmux attach-session -t {}

        case windows win
            # Search windows across all sessions
            tmux list-windows -a -F "#S:#I:#W" 2>/dev/null | \
            fzf --reverse \
                --header 'Search all windows' \
                --preview 'tmux capture-pane -t {1}:{2} -p 2>/dev/null | head -50' \
                --preview-window=right:50% | \
            awk -F: '{print $1":"$2}' | \
            xargs tmux switch-client -t

        case panes
            # Search content in all panes
            set -l panes (tmux list-panes -a -F "#S:#I.#P")
            for pane in $panes
                set -l content (tmux capture-pane -t $pane -p 2>/dev/null)
                if test -n "$content"
                    echo "$pane|$content"
                end
            end | \
            fzf --reverse \
                --delimiter='|' \
                --with-nth=2.. \
                --header 'Search pane content' \
                --preview 'echo {1} | xargs tmux capture-pane -t -p 2>/dev/null' \
                --preview-window=right:50% | \
            cut -d'|' -f1 | \
            xargs tmux switch-client -t

        case history hist
            # Search command history across all panes
            set -l temp_file (mktemp)
            for pane in (tmux list-panes -a -F "#S:#I.#P")
                echo "=== Pane: $pane ===" >> $temp_file
                tmux capture-pane -t $pane -p -S -3000 2>/dev/null | \
                grep -E '^\$|^>' | \
                tail -100 >> $temp_file
            end
            
            cat $temp_file | \
            fzf --reverse \
                --header 'Search command history' \
                --tac | \
            pbcopy
            
            rm -f $temp_file
            echo "Command copied to clipboard"

        case find
            # Find text in current pane
            if not set -q argv[2]
                echo "Usage: tmux-search find <pattern>"
                return 1
            end
            
            set -l pattern $argv[2..-1]
            tmux copy-mode
            tmux send-keys -X search-backward "$pattern"

        case '*'
            echo "tmux-search: Advanced search and filter for tmux"
            echo ""
            echo "Usage: tmux-search <command> [args]"
            echo ""
            echo "Commands:"
            echo "  sessions, sess  - Search and switch sessions"
            echo "  windows, win    - Search and switch windows"
            echo "  panes          - Search content in all panes"
            echo "  history, hist  - Search command history"
            echo "  find <text>    - Find text in current pane"
    end
end