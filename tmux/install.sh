#!/usr/bin/env bash

# Tmux configuration installation script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.tmux-backup-$(date +%Y%m%d-%H%M%S)"

echo "Installing tmux configuration..."

# Create backup directory if existing configs found
if [ -f "$HOME/.tmux.conf" ] || [ -f "$HOME/.tmux.conf.local" ]; then
    echo "Backing up existing tmux configuration to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    [ -f "$HOME/.tmux.conf" ] && cp "$HOME/.tmux.conf" "$BACKUP_DIR/"
    [ -f "$HOME/.tmux.conf.local" ] && cp "$HOME/.tmux.conf.local" "$BACKUP_DIR/"
fi

# Create symlinks
echo "Creating symlinks..."
ln -sf "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$SCRIPT_DIR/.tmux.conf.local" "$HOME/.tmux.conf.local"

# Create tmux-sessionizer script directory if needed
if ! [ -d "$HOME/.local/bin" ]; then
    echo "Creating ~/.local/bin directory..."
    mkdir -p "$HOME/.local/bin"
fi

# Create a simple tmux-sessionizer script
cat > "$HOME/.local/bin/tmux-sessionizer" << 'EOF'
#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/work ~/projects ~/dotfiles -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

if [[ -z $TMUX ]]; then
    tmux attach-session -t $selected_name
else
    tmux switch-client -t $selected_name
fi
EOF

chmod +x "$HOME/.local/bin/tmux-sessionizer"

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "WARNING: tmux is not installed. Please install tmux first."
    echo "  macOS: brew install tmux"
    echo "  Ubuntu/Debian: sudo apt-get install tmux"
    echo "  Fedora: sudo dnf install tmux"
fi

# Reload tmux if running
if pgrep -x tmux > /dev/null; then
    echo "Reloading tmux configuration..."
    tmux source-file "$HOME/.tmux.conf" || true
fi

echo "Installation complete!"
echo ""
echo "Features included:"
echo "  - Beautiful Rose Pine theme"
echo "  - Optimized for Neovim users"
echo "  - Smart pane switching (vim-aware)"
echo "  - Session management keybindings"
echo "  - Mouse support enabled"
echo "  - True color support"
echo ""
echo "Key bindings:"
echo "  - Prefix: Ctrl-a"
echo "  - New session: <prefix> C"
echo "  - Session switcher: <prefix> f (requires fzf)"
echo "  - Split horizontal: <prefix> -"
echo "  - Split vertical: <prefix> _"
echo "  - Navigate panes: <prefix> h/j/k/l or Ctrl-h/j/k/l"
echo "  - Quick window switch: Alt-1 through Alt-9"
echo "  - Resize panes: Shift-Arrow keys"
echo "  - Copy mode: <prefix> Enter"
echo "  - Reload config: <prefix> r"
echo ""
echo "Customize your setup by editing ~/.tmux.conf.local"
