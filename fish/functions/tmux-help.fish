function tmux-help --description "Show categorized tmux keybindings"
    echo "
╭─ Tmux Keybindings (Prefix: Ctrl-b) ─────────────────────────────────────────╮
│                                                                              │
│ 🪟  Windows                          📐 Panes                               │
│   c      Create new window             -       Split horizontal             │
│   ,      Rename window                 _       Split vertical               │
│   &      Kill window                   %       Split horizontal (default)   │
│   n/p    Next/Previous window          \"      Split vertical (default)     │
│   0-9    Go to window number           x       Kill pane                    │
│   w      List all windows              z       Toggle pane zoom             │
│   Tab    Last active window            !       Break pane to window         │
│   C-h/l  Previous/Next window          +       Maximize pane                │
│                                        o       Next pane                    │
│ 🎛️  Sessions                          q       Show pane numbers            │
│   s      List sessions                 ;       Last active pane             │
│   \$      Rename session                {/}     Move pane left/right         │
│   d      Detach from session           >/< Swap pane down/up               │
│   D      Choose client to detach       Space   Cycle pane layouts           │
│   (/)    Previous/Next session         C-o     Rotate panes                 │
│   L      Last session                  M       Clear marked pane            │
│   C      Create new session                                                 │
│   C-c    Create new session          📋 Copy Mode                          │
│   C-f    Find session                  Enter/[ Enter copy mode              │
│                                        v       Start selection (vi mode)    │
│ 🔍 Search & Filter                    y       Copy selection               │
│   /      Search backward               C-v     Rectangle selection          │
│   ?      Search forward                Escape  Cancel                       │
│   f      Quick filter                  H/L     Start/End of line           │
│   F      Search all panes              ]/p     Paste buffer                 │
│   S      Filter sessions (fzf)         P       Choose buffer to paste       │
│   W      Filter windows (fzf)          =       List buffers                 │
│   e      Extract text (extrakto)       b       List buffers                 │
│   C-f    Search files (copycat)                                            │
│   C-g    Search git files            ⚡ Navigation (No Prefix)             │
│   C-u    Search URLs                   Ctrl-h/j/k/l  Navigate panes        │
│   C-d    Search numbers                Alt-h/j/k/l   Quick navigate        │
│   M-i    Search IP addresses           Alt-1 to 9    Switch to window      │
│                                        Shift-Arrow   Resize panes          │
│ 🛠️  Other Commands                                                          │
│   r      Reload configuration        🐟 Fish Shell Commands                │
│   e      Edit local config             tm/t    Tmux session manager        │
│   m      Toggle mouse mode             ts      Search functions            │
│   t      Show time                     tf      Filter functions            │
│   i      Display pane info             tmux-help   Show this help          │
│   :      Command prompt                tmux-keys   Searchable keys         │
│   ?      Show this help                                                     │
│   C-h    Searchable key list         📍 Pane Navigation                    │
│   U      Open URLs (tmux-open)         h/j/k/l Navigate (vim-style)        │
│   F      Facebook PathPicker           H/J/K/L Resize panes               │
│   BTab   Last session                                                      │
│                                                                              │
╰──────────────────────────────────────────────────────────────────────────────╯"
end