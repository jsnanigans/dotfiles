# Tmux Configuration

A beautiful and fast tmux setup optimized for Neovim users and multiple project workflows, featuring the Rose Pine theme.

## Features

- 🎨 **Rose Pine Theme** - Beautiful dark theme with carefully chosen colors
- ⚡ **Neovim Optimized** - Zero escape time, focus events, and true color support
- 🖱️ **Mouse Support** - Enabled by default for easy pane selection and scrolling
- 🔀 **Smart Pane Navigation** - Seamlessly navigate between tmux panes and Neovim splits
- 📁 **Project Management** - Quick session switching with tmux-sessionizer
- ⌨️ **Intuitive Keybindings** - Vim-like navigation and convenient shortcuts
- 🐟 **Fish Shell** - Set as default shell for better terminal experience

## Installation

```bash
cd ~/dotfiles/tmux
./install.sh
```

The installer will:
- Backup any existing tmux configuration
- Create symlinks to the config files
- Set up the tmux-sessionizer script
- Reload tmux if it's running

## Key Bindings

### Prefix
- `Ctrl-a` - Main prefix key (GNU Screen compatible)

### Session Management
- `<prefix> C` - Create new session with prompt
- `<prefix> f` - Session fuzzy finder (requires fzf)
- `<prefix> C-c` - Create new session
- `<prefix> C-f` - Find session

### Window Management
- `<prefix> c` - Create new window
- `<prefix> ,` - Rename current window
- `<prefix> &` - Kill current window
- `<prefix> Tab` - Last active window
- `<prefix> C-h/C-l` - Navigate windows
- `Alt-1` to `Alt-9` - Quick window switching (no prefix needed)

### Pane Management
- `<prefix> -` - Split pane horizontally
- `<prefix> _` - Split pane vertically
- `<prefix> x` - Kill current pane
- `<prefix> +` - Maximize current pane
- `<prefix> z` - Toggle pane zoom
- `<prefix> h/j/k/l` - Navigate panes
- `Ctrl-h/j/k/l` - Smart pane navigation (works with Neovim)
- `Alt-h/j/k/l` - Quick pane switching (no prefix needed)
- `<prefix> H/J/K/L` - Resize panes
- `Shift-Arrow` - Resize panes (no prefix needed)

### Copy Mode
- `<prefix> Enter` - Enter copy mode
- `v` - Start selection (in copy mode)
- `y` - Copy selection
- `<prefix> p` - Paste from buffer
- `<prefix> P` - Choose buffer to paste

### Other
- `<prefix> r` - Reload configuration
- `<prefix> e` - Edit local configuration
- `<prefix> m` - Toggle mouse mode
- `<prefix> b` - List paste buffers

## Configuration Files

### `.tmux.conf`
The main configuration file containing core settings. This file should not be edited directly as it may be updated.

### `.tmux.conf.local`
Your personal configuration file for customizations. This is where you should add your own settings, key bindings, and overrides.

## Customization

### Changing Colors
Edit `~/.tmux.conf.local` and modify the color variables in the theme section. The configuration uses Rose Pine colors by default.

### Status Bar
The status bar can be customized by modifying these variables in `.tmux.conf.local`:
- `tmux_conf_theme_status_left` - Left side content
- `tmux_conf_theme_status_right` - Right side content

### Adding Plugins
While this configuration doesn't use TPM by default, you can enable it by uncommenting the plugin section in `.tmux.conf.local`.

## Tips

### Project Navigation
The included tmux-sessionizer (`<prefix> f`) searches for projects in:
- `~/work`
- `~/projects`
- `~/dotfiles`

You can modify these paths in `~/.local/bin/tmux-sessionizer`.

### Neovim Integration
For the best experience with Neovim:
1. Install [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) in Neovim
2. Use `Ctrl-h/j/k/l` to seamlessly navigate between Neovim splits and tmux panes

### True Color Support
This configuration enables true color support. Ensure your terminal emulator also supports true colors for the best visual experience.

## Troubleshooting

### Colors look wrong
1. Ensure your terminal supports true colors
2. Check that `$TERM` is set correctly
3. Try setting `tmux_conf_24b_colour=true` in `.tmux.conf.local`

### Fish shell not found
If tmux can't find fish, update the path in `.tmux.conf.local`:
```bash
set -g default-shell /path/to/fish
```

### Mouse not working
Mouse support is enabled by default. If it's not working:
1. Check your terminal emulator's mouse support
2. Try toggling with `<prefix> m`

## Dependencies

- **tmux** 2.6+ (3.0+ recommended)
- **fish** shell (optional, but configured as default)
- **fzf** (optional, for session switcher)
- **Neovim** (optional, for editor integration)

## Credits

Inspired by [gpakosz/.tmux](https://github.com/gpakosz/.tmux) with modifications for Neovim users and Rose Pine theme integration.