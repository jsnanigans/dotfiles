# 🚀 Ultimate Tmux Configuration Guide

A comprehensive collection of the best tmux configurations, tips, tricks, and plugins gathered from across the tmux community.

## 📚 Table of Contents

- [Core Configuration](#core-configuration)
- [Essential Key Bindings](#essential-key-bindings)
- [Plugin Management](#plugin-management)
- [Theme & Status Bar](#theme--status-bar)
- [Session Management](#session-management)
- [Advanced Tips & Tricks](#advanced-tips--tricks)
- [Vim Integration](#vim-integration)
- [Must-Have Plugins](#must-have-plugins)
- [Performance Optimizations](#performance-optimizations)

## Core Configuration

### 🎯 Essential Settings

```bash
# Enable true color support
set -g default-terminal "screen-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# Set scrollback buffer size
set -g history-limit 50000

# Enable mouse support
set -g mouse on

# Faster command sequences (no delay after escape)
set -sg escape-time 0

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Activity monitoring
setw -g monitor-activity on
set -g visual-activity off

# Enable focus events
set -g focus-events on

# Aggressive resize
setw -g aggressive-resize on
```

### 🔑 Prefix Key Options

```bash
# Popular alternatives to default C-b
# Option 1: C-a (like GNU Screen)
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Option 2: C-Space (keeps hands on home row)
set -g prefix C-Space
bind C-Space send-prefix

# Option 3: Backtick (quick access)
set -g prefix `
bind ` send-prefix
```

## Essential Key Bindings

### 🪟 Window & Pane Management

```bash
# Split panes using | and - (more intuitive)
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# Create new window in current directory
bind c new-window -c "#{pane_current_path}"

# Quick window switching
bind -n M-h previous-window
bind -n M-l next-window

# Swap windows
bind -r "<" swap-window -d -t -1
bind -r ">" swap-window -d -t +1

# Join/break panes
bind j choose-window 'join-pane -h -s "%%"'
bind J choose-window 'join-pane -s "%%"'
bind b break-pane -d

# Toggle between last windows
bind Space last-window
bind Tab last-window

# Kill pane/window without confirmation
bind x kill-pane
bind X kill-window
```

### 🧭 Navigation (Vim-style)

```bash
# Pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Pane resizing
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Alternative: Use Alt without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
```

### 📋 Copy Mode Enhancements

```bash
# Use vim keybindings in copy mode
setw -g mode-keys vi

# Better copy mode bindings
bind Enter copy-mode
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
bind -T copy-mode-vi Escape send-keys -X cancel
bind -T copy-mode-vi H send-keys -X start-of-line
bind -T copy-mode-vi L send-keys -X end-of-line

# Copy to system clipboard
# macOS
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"

# Linux (requires xclip)
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"
```

## Plugin Management

### 🔌 TPM (Tmux Plugin Manager)

```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Add to tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Initialize TPM (keep at bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

# Key bindings
# prefix + I - Install plugins
# prefix + U - Update plugins
# prefix + alt + u - Uninstall plugins
```

## Theme & Status Bar

### 🎨 Powerline-Style Configuration

```bash
# Status bar customization
set -g status on
set -g status-interval 1
set -g status-position bottom
set -g status-justify left
set -g status-style 'bg=colour235 fg=colour137'

# Left side
set -g status-left-length 50
set -g status-left '#[fg=colour232,bg=colour154] #S #[fg=colour154,bg=colour238]#[fg=colour222,bg=colour238] #W #[fg=colour238,bg=colour235]'

# Right side
set -g status-right-length 100
set -g status-right '#[fg=colour238]#[fg=colour251,bg=colour238] %H:%M:%S #[fg=colour244]#[fg=colour232,bg=colour244] %Y-%m-%d #[fg=colour154]#[fg=colour232,bg=colour154] #h '

# Window status
setw -g window-status-format '#[fg=colour246,bg=colour235] #I:#W#F '
setw -g window-status-current-format '#[fg=colour235,bg=colour238]#[fg=colour81,bg=colour238] #I:#W#F #[fg=colour238,bg=colour235]'

# Pane borders
set -g pane-border-style 'fg=colour238'
set -g pane-active-border-style 'fg=colour154'

# Message style
set -g message-style 'fg=colour232 bg=colour154'
```

### 📊 Useful Status Bar Elements

```bash
# Battery status (requires battery plugin)
set -g @plugin 'tmux-plugins/tmux-battery'
set -g status-right '#{battery_status_bg} Batt: #{battery_percentage} | %a %h-%d %H:%M '

# CPU and memory
set -g @plugin 'tmux-plugins/tmux-cpu'
set -g status-right 'CPU: #{cpu_percentage} | %a %h-%d %H:%M '

# Git status
set -g status-right '#(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD)'

# Weather (requires internet)
set -g status-right '#(curl -s wttr.in?format=3) | %H:%M'

# Network status
set -g @plugin 'tmux-plugins/tmux-online-status'
set -g status-right "Online: #{online_status} | %a %h-%d %H:%M"
```

## Session Management

### 💾 Session Persistence

```bash
# Automatic session save/restore
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# Resurrect settings
set -g @resurrect-capture-pane-contents 'on'
set -g @resurrect-strategy-vim 'session'
set -g @resurrect-strategy-nvim 'session'
set -g @resurrect-save 'S'
set -g @resurrect-restore 'R'

# Continuum settings
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15' # minutes
```

### 🔍 Session Navigation

```bash
# Session switcher with fzf
bind s display-popup -E "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"

# Quick session switching
bind -r ( switch-client -p
bind -r ) switch-client -n

# Create named session
bind C-c command-prompt -p "New Session:" "new-session -A -s '%%'"

# Kill session
bind C-x confirm kill-session
```

## Advanced Tips & Tricks

### 🚀 Productivity Boosters

```bash
# Synchronize panes (type in all panes simultaneously)
bind C-s setw synchronize-panes

# Toggle pane zoom
bind z resize-pane -Z

# Clear screen and scrollback
bind C-l send-keys C-l \; clear-history

# Reload configuration
bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

# Display pane numbers longer
set -g display-panes-time 2000

# Popup window (tmux 3.2+)
bind g display-popup -E "tmux new-session -A -s scratch"

# Floating terminal
bind -n M-f display-popup -E -w 80% -h 80%

# Quick notes
bind h split-window -h "vim ~/notes.md"
```

### 🎯 Smart Pane Management

```bash
# Smart pane switching with awareness of Vim splits
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"

# Pane layouts
bind M-1 select-layout main-horizontal
bind M-2 select-layout main-vertical
bind M-3 select-layout even-horizontal
bind M-4 select-layout even-vertical
bind M-5 select-layout tiled
```

## Vim Integration

### 🔗 Seamless Navigation

```bash
# Install vim-tmux-navigator plugin
set -g @plugin 'christoomey/vim-tmux-navigator'

# Custom navigation bindings
bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-h) || tmux select-pane -L"
bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-j) || tmux select-pane -D"
bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-k) || tmux select-pane -U"
bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-l) || tmux select-pane -R"

# Clear screen with prefix + C-l (since C-l is used for navigation)
bind C-l send-keys 'C-l'
```

## Must-Have Plugins

### 🌟 Essential Plugin Collection

```bash
# Core functionality
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-pain-control'

# Session management
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-sessionist'

# Copy/paste enhancements
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-copycat'
set -g @plugin 'tmux-plugins/tmux-open'

# Navigation
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'schasse/tmux-jump'
set -g @plugin 'fcsonline/tmux-thumbs'

# Status bar
set -g @plugin 'tmux-plugins/tmux-battery'
set -g @plugin 'tmux-plugins/tmux-cpu'
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'

# File/URL handling
set -g @plugin 'tmux-plugins/tmux-fpp'
set -g @plugin 'wfxr/tmux-fzf-url'

# Search
set -g @plugin 'roosta/tmux-fuzzback'

# Themes
set -g @plugin 'dracula/tmux'
# or
set -g @plugin 'arcticicestudio/nord-tmux'
# or
set -g @plugin 'catppuccin/tmux'
```

### 🔥 Advanced Plugins

```bash
# Floating scratch terminal
set -g @plugin 'momo-lab/tmux-toggle-scratch'

# Better mouse mode
set -g @plugin 'NHDaly/tmux-better-mouse-mode'

# Sidebar file tree
set -g @plugin 'tmux-plugins/tmux-sidebar'

# Logging
set -g @plugin 'tmux-plugins/tmux-logging'

# Modal mode (like vim)
set -g @plugin 'whame/tmux-modal'

# Pomodoro timer
set -g @plugin 'olimorris/tmux-pomodoro-plus'
```

## Performance Optimizations

### ⚡ Speed Improvements

```bash
# Faster key repetition
set -g repeat-time 200

# Reduce time tmux waits for escape sequences
set -sg escape-time 0

# Increase scrollback buffer
set -g history-limit 50000

# Boost performance in vim
set -g focus-events on

# Don't rename windows automatically
set -g allow-rename off

# Quiet mode
set -g visual-activity off
set -g visual-bell off
set -g visual-silence off
setw -g monitor-activity off
set -g bell-action none

# Terminal overrides for better performance
set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
```

### 🛠️ Troubleshooting Tips

```bash
# Debug mode
bind F5 set -g status-left "#{pane_current_path}"
bind F6 set -g status-right "#{pane_current_command}"

# Show all key bindings
bind ? list-keys

# Show current settings
bind F7 show-options -g

# Monitor pane output
bind m pipe-pane -o "cat >>~/tmux-output.#I-#P"

# Toggle mouse mode quickly
bind M set -g mouse \; display "Mouse: #{?mouse,ON,OFF}"
```

## 🎓 Pro Tips

1. **Use tmuxinator or smug** for project-specific layouts
2. **Enable clipboard integration** for seamless copy/paste
3. **Map Caps Lock to Ctrl** for easier prefix access
4. **Use popup windows** (tmux 3.2+) for quick tasks
5. **Create custom scripts** in `~/.tmux/scripts/` for complex operations
6. **Use hooks** for automatic actions on events
7. **Learn the command mode** (prefix + :) for quick changes
8. **Use display-message** for debugging and notifications
9. **Leverage tmux buffers** for multiple clipboard items
10. **Use run-shell** for integrating external tools

## 🔗 Resources

- [Oh My Tmux!](https://github.com/gpakosz/.tmux) - Popular tmux configuration framework
- [Awesome Tmux](https://github.com/rothgar/awesome-tmux) - Curated list of tmux resources
- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) - Essential plugin manager
- [tmux 2: Productive Mouse-Free Development](https://pragprog.com/titles/bhtmux3/tmux-3/) - Comprehensive book
- [Ham Vocke's Guide](https://hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/) - Excellent configuration tutorial

## 📝 Quick Start Template

```bash
# Save this as ~/.tmux.conf for a solid starting configuration

# Prefix
set -g prefix C-Space
unbind C-b

# Options
set -g mouse on
set -g base-index 1
set -g history-limit 10000
set -sg escape-time 0
setw -g mode-keys vi

# Splits
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Resize
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Reload
bind r source-file ~/.tmux.conf \; display "Reloaded!"

# Plugins (install TPM first)
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'christoomey/vim-tmux-navigator'

# Initialize TPM
run '~/.tmux/plugins/tpm/tpm'
```

---

*Remember: The best tmux configuration is the one that fits your workflow. Start with basics and gradually add features as you need them!*
