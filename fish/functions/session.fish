#!/usr/bin/env fish
# Unified session management system

function session --description "Unified session manager for tmux"
    # Load project configuration
    source $DOTFILES/fish/conf.d/projects.fish

    set -l cmd $argv[1]
    set -l args $argv[2..-1]

    switch $cmd
        case "" list ls
            # List all sessions with project info
            _session_list

        case new n create c
            # Create or switch to a session
            _session_new $args

        case project p proj
            # Project-based session management
            _session_project $args

        case switch s sw
            # Switch to existing session
            _session_switch $args

        case attach a
            # Attach to session
            _session_attach $args

        case kill k rm remove
            # Kill session(s)
            _session_kill $args

        case rename r mv
            # Rename session
            _session_rename $args

        case clone
            # Clone current session
            _session_clone $args

        case save
            # Save session layout
            _session_save $args

        case restore
            # Restore session layout
            _session_restore $args

        case clean cleanup
            # Clean up orphaned sessions
            _session_cleanup

        case info i
            # Show session info
            _session_info $args

        case help h '*'
            _session_help
    end
end

# Helper functions

function _session_list --description "List all sessions with details"
    set -l sessions (tmux list-sessions -F "#{session_name}|#{session_windows}|#{session_attached}|#{session_created}|#{session_activity}" 2>/dev/null)

    if test (count $sessions) -eq 0
        echo "No active tmux sessions"
        return
    end

    echo "Active Sessions:"
    echo "────────────────────────────────────────────"

    for session in $sessions
        set -l parts (string split "|" $session)
        set -l name $parts[1]
        set -l windows $parts[2]
        set -l attached $parts[3]
        set -l created $parts[4]

        # Check if session corresponds to a project
        set -l project_path (find_project_by_name $name)
        set -l project_marker ""
        if test -n "$project_path"
            set project_marker "📁"
        end

        # Format attachment status
        set -l attach_status ""
        if test "$attached" = "1"
            set attach_status "●"
        else
            set attach_status "○"
        end

        printf "%s %-20s %s Windows: %-2d  %s\n" \
            $attach_status \
            $name \
            $project_marker \
            $windows \
            (test -n "$project_path" && echo "($project_path)" || echo "")
    end
end

function _session_new --description "Create or switch to a session"
    set -l session_name ""
    set -l session_dir ""

    if test (count $argv) -eq 0
        # Interactive mode - select from projects
        set -l project_path (select_project "Select project for new session")
        if test -z "$project_path"
            return 1
        end
        set session_name (project_name_from_path "$project_path")
        set session_dir "$project_path"
    else if test (count $argv) -eq 1
        set session_name $argv[1]
        # Check if it's a project name
        set -l project_path (find_project_by_name $session_name)
        if test -n "$project_path"
            set session_dir "$project_path"
        else
            set session_dir (pwd)
        end
    else
        set session_name $argv[1]
        set session_dir $argv[2]
    end

    # Sanitize session name
    set session_name (echo $session_name | eval $SESSION_NAME_TRANSFORM)

    # Check if session exists
    if tmux has-session -t "$session_name" 2>/dev/null
        echo "Session '$session_name' already exists"
        if set -q TMUX
            tmux switch-client -t "$session_name"
        else
            tmux attach-session -t "$session_name"
        end
    else
        # Create new session
        if set -q TMUX
            tmux new-session -d -s "$session_name" -c "$session_dir"
            tmux switch-client -t "$session_name"
        else
            tmux new-session -s "$session_name" -c "$session_dir"
        end
        echo "Created session '$session_name' in $session_dir"
    end
end

function _session_project --description "Project-based session management"
    set -l subcmd $argv[1]

    switch $subcmd
        case "" open o
            # Open project in session
            set -l project_path (select_project "Select project to open")
            if test -n "$project_path"
                set -l session_name (project_name_from_path "$project_path")
                _session_new $session_name "$project_path"
            end

        case current c
            # Show current project info
            set -l project (current_project)
            if test -n "$project"
                project_info "$project"
            else
                echo "Not in a project directory"
            end

        case list ls
            # List all projects
            echo "Available Projects:"
            for project in (discover_projects)
                set -l name (project_name_from_path "$project")
                set -l active ""
                if tmux has-session -t "$name" 2>/dev/null
                    set active "● "
                end
                printf "%s%-20s %s\n" "$active" "$name" "$project"
            end

        case sync
            # Sync session name with current project
            if not set -q TMUX
                echo "Not in a tmux session"
                return 1
            end

            set -l project (current_project)
            if test -n "$project"
                set -l new_name (project_name_from_path "$project")
                set -l current_session (tmux display-message -p '#S')
                if test "$current_session" != "$new_name"
                    tmux rename-session "$new_name"
                    echo "Renamed session to '$new_name'"
                end
            end

        case '*'
            echo "Unknown project subcommand: $subcmd"
    end
end

function _session_switch --description "Switch to a session"
    if not set -q TMUX
        echo "Not in a tmux session"
        return 1
    end

    set -l target ""
    if test (count $argv) -eq 0
        # Interactive selection
        set -l sessions (tmux list-sessions -F "#{session_name}" 2>/dev/null)
        set target (printf '%s\n' $sessions | \
            fzf --reverse \
                --header "Switch to session" \
                --preview 'tmux list-windows -t {} -F "#I:#W" | head -10' \
                --preview-window=right:30%)
    else
        set target $argv[1]
    end

    if test -n "$target"
        tmux switch-client -t "$target"
    end
end

function _session_attach --description "Attach to a session"
    if set -q TMUX
        echo "Already in a tmux session"
        return 1
    end

    set -l target ""
    if test (count $argv) -eq 0
        # Interactive selection
        set -l sessions (tmux list-sessions -F "#{session_name}" 2>/dev/null)
        if test (count $sessions) -eq 0
            echo "No sessions available"
            return 1
        end

        set target (printf '%s\n' $sessions | \
            fzf --reverse \
                --header "Attach to session" \
                --preview 'tmux list-windows -t {} -F "#I:#W" | head -10' \
                --preview-window=right:30%)
    else
        set target $argv[1]
    end

    if test -n "$target"
        tmux attach-session -t "$target"
    end
end

function _session_kill --description "Kill session(s)"
    set -l targets

    if test (count $argv) -eq 0
        # Interactive multi-selection
        set -l sessions (tmux list-sessions -F "#{session_name}" 2>/dev/null)
        if test (count $sessions) -eq 0
            echo "No sessions to kill"
            return
        end

        set targets (printf '%s\n' $sessions | \
            fzf --multi \
                --reverse \
                --header "Select sessions to kill (Tab to select multiple)" \
                --preview 'tmux list-windows -t {} -F "#I:#W" | head -10' \
                --preview-window=right:30%)
    else if test "$argv[1]" = "all"
        set targets (tmux list-sessions -F "#{session_name}" 2>/dev/null)
    else
        set targets $argv
    end

    for target in $targets
        tmux kill-session -t "$target" 2>/dev/null
        and echo "Killed session: $target"
    end
end

function _session_rename --description "Rename a session"
    if test (count $argv) -lt 1
        echo "Usage: session rename [old_name] <new_name>"
        return 1
    end

    set -l old_name ""
    set -l new_name ""

    if test (count $argv) -eq 1
        # Rename current session
        if not set -q TMUX
            echo "Not in a tmux session"
            return 1
        end
        set old_name (tmux display-message -p '#S')
        set new_name $argv[1]
    else
        set old_name $argv[1]
        set new_name $argv[2]
    end

    # Sanitize new name
    set new_name (echo $new_name | eval $SESSION_NAME_TRANSFORM)

    tmux rename-session -t "$old_name" "$new_name" 2>/dev/null
    and echo "Renamed '$old_name' to '$new_name'"
end

function _session_clone --description "Clone current session"
    if not set -q TMUX
        echo "Not in a tmux session"
        return 1
    end

    set -l current_session (tmux display-message -p '#S')
    set -l new_name "$current_session"_clone

    if test (count $argv) -gt 0
        set new_name $argv[1]
    end

    set new_name (echo $new_name | eval $SESSION_NAME_TRANSFORM)

    # Get current directory
    set -l current_dir (tmux display-message -p '#{pane_current_path}')

    tmux new-session -d -s "$new_name" -c "$current_dir"
    echo "Cloned session '$current_session' to '$new_name'"

    read -P "Switch to cloned session? [y/N] " -n 1 response
    if test "$response" = "y" -o "$response" = "Y"
        tmux switch-client -t "$new_name"
    end
end

function _session_save --description "Save session layout"
    set -l session_name ""
    if test (count $argv) -eq 0
        if set -q TMUX
            set session_name (tmux display-message -p '#S')
        else
            echo "Specify session name or run from within tmux"
            return 1
        end
    else
        set session_name $argv[1]
    end

    set -l save_dir "$HOME/.config/tmux/sessions"
    mkdir -p "$save_dir"

    set -l save_file "$save_dir/$session_name.tmux"

    # Save session layout
    echo "#!/usr/bin/env bash" > "$save_file"
    echo "# Saved session: $session_name" >> "$save_file"
    echo "# Date: "(date) >> "$save_file"
    echo "" >> "$save_file"

    # Get session info
    tmux list-windows -t "$session_name" -F "#{window_index}|#{window_name}|#{pane_current_path}" | while read -l window
        set -l parts (string split "|" $window)
        echo "tmux new-window -t '$session_name:$parts[1]' -n '$parts[2]' -c '$parts[3]'" >> "$save_file"
    end

    chmod +x "$save_file"
    echo "Saved session layout to $save_file"
end

function _session_restore --description "Restore session layout"
    set -l save_dir "$HOME/.config/tmux/sessions"

    if test (count $argv) -eq 0
        # List available saves
        echo "Available session saves:"
        for save in "$save_dir"/*.tmux
            if test -f "$save"
                echo "  - "(basename "$save" .tmux)
            end
        end
        return
    end

    set -l session_name $argv[1]
    set -l save_file "$save_dir/$session_name.tmux"

    if not test -f "$save_file"
        echo "No saved session found: $session_name"
        return 1
    end

    # Create session if it doesn't exist
    if not tmux has-session -t "$session_name" 2>/dev/null
        tmux new-session -d -s "$session_name"
    end

    # Execute restore script
    bash "$save_file"
    echo "Restored session: $session_name"
end

function _session_cleanup --description "Clean up orphaned sessions"
    set -l orphaned 0

    for session in (tmux list-sessions -F "#{session_name}|#{session_attached}" 2>/dev/null)
        set -l parts (string split "|" $session)
        set -l name $parts[1]
        set -l attached $parts[2]

        # Check if unattached and no corresponding project
        if test "$attached" = "0"
            set -l project_path (find_project_by_name $name)
            if test -z "$project_path"
                # Check if session has only one window with one pane
                set -l window_count (tmux list-windows -t "$name" 2>/dev/null | wc -l)
                if test $window_count -eq 1
                    echo "Cleaning up orphaned session: $name"
                    tmux kill-session -t "$name" 2>/dev/null
                    set orphaned (math $orphaned + 1)
                end
            end
        end
    end

    if test $orphaned -eq 0
        echo "No orphaned sessions found"
    else
        echo "Cleaned up $orphaned orphaned sessions"
    end
end

function _session_info --description "Show detailed session information"
    set -l session_name ""

    if test (count $argv) -eq 0
        if set -q TMUX
            set session_name (tmux display-message -p '#S')
        else
            echo "Specify session name or run from within tmux"
            return 1
        end
    else
        set session_name $argv[1]
    end

    if not tmux has-session -t "$session_name" 2>/dev/null
        echo "Session not found: $session_name"
        return 1
    end

    echo "Session: $session_name"
    echo "────────────────────────────"

    # Get session info
    set -l info (tmux list-sessions -F "#{session_created}|#{session_activity}|#{session_attached}|#{session_windows}" -f "#{==:#{session_name},$session_name}" 2>/dev/null)
    set -l parts (string split "|" $info)

    echo "Created: "(date -r $parts[1] 2>/dev/null || echo $parts[1])
    echo "Last activity: "(date -r $parts[2] 2>/dev/null || echo $parts[2])
    echo "Attached: "(test "$parts[3]" = "1" && echo "Yes" || echo "No")
    echo "Windows: $parts[4]"

    # Check for associated project
    set -l project_path (find_project_by_name $session_name)
    if test -n "$project_path"
        echo "Project: $project_path"
    end

    echo ""
    echo "Windows:"
    tmux list-windows -t "$session_name" -F "  #I: #W (#{window_panes} panes) - #{pane_current_path}" 2>/dev/null
end

function _session_help --description "Show session manager help"
    echo "Unified Session Manager"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Usage: session [command] [args]"
    echo ""
    echo "Core Commands:"
    echo "  session              - List all sessions"
    echo "  session new [name]   - Create/switch to session"
    echo "  session project      - Project-based sessions"
    echo "  session switch       - Switch between sessions"
    echo "  session attach       - Attach to a session"
    echo "  session kill [name]  - Kill session(s)"
    echo ""
    echo "Advanced Commands:"
    echo "  session rename       - Rename a session"
    echo "  session clone        - Clone current session"
    echo "  session save         - Save session layout"
    echo "  session restore      - Restore session layout"
    echo "  session clean        - Clean orphaned sessions"
    echo "  session info         - Show session details"
    echo ""
    echo "Project Subcommands:"
    echo "  session project      - Open project selector"
    echo "  session project list - List all projects"
    echo "  session project current - Show current project"
    echo "  session project sync - Sync session name with project"
    echo ""
    echo "Aliases: ls=list, n=new, p=project, s=switch, a=attach, k=kill"
    echo ""
    echo "Configuration:"
    echo "  PROJECT_PATHS - Directories to search for projects"
    echo "  PROJECT_MARKERS - Files/dirs that identify projects"
    echo ""
    echo "Examples:"
    echo "  session new myproject      - Create session 'myproject'"
    echo "  session project            - Select and open project"
    echo "  session kill all           - Kill all sessions"
    echo "  session clone backup       - Clone current to 'backup'"
end

# Add convenient aliases
abbr -a s session
abbr -a sp 'session project'
abbr -a sn 'session new'
abbr -a sk 'session kill'
abbr -a ss 'session switch'
