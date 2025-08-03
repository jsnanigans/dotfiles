function tmux-keys --description "Display tmux keybindings in a searchable menu"
    # Create a formatted list of keybindings with descriptions
    set -l keys (tmux list-keys | sed 's/bind-key//' | sed 's/\s\+/ /g')
    
    # Custom descriptions for common keys
    set -l descriptions
    set descriptions "C-b ?" "Show this help menu"
    set descriptions "C-b c" "Create new window"
    set descriptions "C-b ," "Rename current window"
    set descriptions "C-b &" "Kill current window"
    set descriptions "C-b n" "Next window"
    set descriptions "C-b p" "Previous window"
    set descriptions "C-b l" "Last window"
    set descriptions "C-b 0-9" "Switch to window number"
    set descriptions "C-b w" "List windows"
    set descriptions "C-b s" "List sessions"
    set descriptions "C-b d" "Detach from session"
    set descriptions "C-b D" "Choose client to detach"
    set descriptions "C-b \$" "Rename session"
    set descriptions "C-b (" "Switch to previous session"
    set descriptions "C-b )" "Switch to next session"
    set descriptions "C-b L" "Switch to last session"
    set descriptions "C-b %" "Split pane horizontally (default)"
    set descriptions "C-b \"" "Split pane vertically (default)"
    set descriptions "C-b -" "Split pane horizontally (custom)"
    set descriptions "C-b _" "Split pane vertically (custom)"
    set descriptions "C-b o" "Go to next pane"
    set descriptions "C-b ;" "Go to last active pane"
    set descriptions "C-b h/j/k/l" "Navigate panes (vim-style)"
    set descriptions "C-b H/J/K/L" "Resize panes"
    set descriptions "C-b x" "Kill current pane"
    set descriptions "C-b z" "Toggle pane zoom"
    set descriptions "C-b Space" "Toggle/cycle pane layouts"
    set descriptions "C-b !" "Break pane into window"
    set descriptions "C-b {" "Move pane left"
    set descriptions "C-b }" "Move pane right"
    set descriptions "C-b +" "Maximize current pane (custom)"
    set descriptions "C-b >" "Swap pane with next"
    set descriptions "C-b <" "Swap pane with previous"
    set descriptions "C-b C-o" "Rotate panes in window"
    set descriptions "C-b M" "Clear marked pane"
    set descriptions "C-b C-h" "Previous window (custom)"
    set descriptions "C-b C-l" "Next window (custom)"
    set descriptions "C-b Tab" "Last active window"
    set descriptions "C-b BTab" "Switch to last session"
    set descriptions "C-b C-c" "Create new session"
    set descriptions "C-b C" "Create new session with prompt"
    set descriptions "C-b Enter" "Enter copy mode"
    set descriptions "C-b [" "Enter copy mode"
    set descriptions "C-b ]" "Paste buffer"
    set descriptions "C-b p" "Paste buffer"
    set descriptions "C-b P" "Choose buffer to paste"
    set descriptions "C-b =" "List paste buffers"
    set descriptions "C-b /" "Search backward (custom)"
    set descriptions "C-b ?" "Search forward (custom)"
    set descriptions "C-b f" "Quick filter (custom)"
    set descriptions "C-b F" "Search all panes (custom)"
    set descriptions "C-b S" "Filter sessions (custom)"
    set descriptions "C-b W" "Filter windows (custom)"
    set descriptions "C-b C-f" "Search files (copycat)"
    set descriptions "C-b C-g" "Search git files (copycat)"
    set descriptions "C-b C-u" "Search URLs (copycat)"
    set descriptions "C-b C-d" "Search digits (copycat)"
    set descriptions "C-b M-i" "Search IPs (copycat)"
    set descriptions "C-b e" "Extract text (extrakto)"
    set descriptions "C-b r" "Reload configuration"
    set descriptions "C-b t" "Show time"
    set descriptions "C-b i" "Display pane info"
    set descriptions "C-b q" "Display pane numbers"
    set descriptions "C-b m" "Toggle mouse mode"
    set descriptions "C-b U" "Open URLs/urlview"
    set descriptions "C-b O" "Open file in editor (tmux-open)"
    set descriptions "C-b C-y" "Copy to system clipboard (tmux-yank)"
    set descriptions "C-b Alt-h" "Search SHA hashes (copycat)"
    set descriptions "C-b I" "Install tmux plugins (TPM)"
    set descriptions "C-b u" "Update tmux plugins (TPM)"
    set descriptions "C-b Alt-u" "Uninstall unused plugins (TPM)"
    set descriptions "C-b F" "Facebook PathPicker"
    set descriptions "C-b C-z" "Suspend tmux client"
    
    # Build the menu content
    set -l menu_items
    for i in (seq 1 2 (count $descriptions))
        set -l key $descriptions[$i]
        set -l desc $descriptions[(math $i + 1)]
        set -a menu_items (printf "%-20s %s" $key $desc)
    end
    
    # Add custom section for non-prefix keys
    set -a menu_items ""
    set -a menu_items "=== Keys without prefix ==="
    set -a menu_items (printf "%-20s %s" "Ctrl-h/j/k/l" "Navigate panes (vim-aware)")
    set -a menu_items (printf "%-20s %s" "Alt-h/j/k/l" "Quick pane navigation")
    set -a menu_items (printf "%-20s %s" "Alt-1 to Alt-9" "Quick window switching")
    set -a menu_items (printf "%-20s %s" "Shift-Arrow" "Resize panes")
    set -a menu_items ""
    set -a menu_items "=== Fish shell commands ==="
    set -a menu_items (printf "%-20s %s" "tm" "Tmux session manager")
    set -a menu_items (printf "%-20s %s" "ts" "Tmux search functions")
    set -a menu_items (printf "%-20s %s" "tf" "Tmux filter functions")
    
    # Show in fzf
    printf '%s\n' $menu_items | fzf --reverse --header 'Tmux Keybindings (ESC to close)'
end