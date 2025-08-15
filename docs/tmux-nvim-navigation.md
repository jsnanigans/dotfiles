# Tmux and Neovim Seamless Navigation Setup

This configuration enables seamless navigation between tmux panes and nvim splits using `<C-h/j/k/l>`.

## Features

- **Unified Navigation**: Use `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` to move between:
  - Neovim splits
  - Tmux panes
  - Seamlessly between both

- **Smart Detection**: The system automatically detects whether you're in nvim or a tmux pane and routes the navigation appropriately

- **Previous Pane**: Use `<C-\>` to jump to the previously active pane/split

## Components

### 1. Neovim Plugin
- **Plugin**: `christoomey/vim-tmux-navigator`
- **Location**: `/Users/brendanmullins/dotfiles/nvim/marvim/lua/config/plugins/navigation.lua`
- **Features**:
  - Saves files on switch (`save_on_switch = 2`)
  - Preserves zoom state
  - Works even when tmux pane is zoomed

### 2. Tmux Configuration
- **Main Config**: `/Users/brendanmullins/dotfiles/tmux/vim-navigation.conf`
- **Features**:
  - Detects if current pane is running vim/nvim
  - Passes navigation keys to vim when detected
  - Handles navigation between tmux panes otherwise

## Key Bindings

### Navigation (Works in both tmux and nvim)
- `<C-h>` - Navigate left
- `<C-j>` - Navigate down  
- `<C-k>` - Navigate up
- `<C-l>` - Navigate right
- `<C-\>` - Navigate to previous pane/split

### Tmux-specific
- `prefix + h/j/k/l` - Navigate panes (fallback)
- `prefix + H/J/K/L` - Resize panes
- `prefix + C-l` - Clear screen (since C-l is used for navigation)
- `prefix + l` - Clear screen (alternative)

### Window Management (Tmux)
- `prefix + -` - Split horizontally
- `prefix + _` - Split vertically
- `prefix + Tab` - Last window

## Installation

1. **Neovim**: The plugin will be automatically installed by Lazy.nvim on next nvim start

2. **Tmux**: Reload tmux configuration:
   ```bash
   tmux source-file ~/.tmux.conf
   ```

## Troubleshooting

### Clear Screen
Since `<C-l>` is used for navigation, use these alternatives to clear the terminal:
- In tmux: `prefix + C-l` or `prefix + l`
- Or simply type `clear` command

### Plugin Not Working
1. Ensure tmux is running with the updated configuration
2. Restart nvim to install the plugin
3. Check that the vim-tmux-navigator plugin is loaded: `:Lazy`

### Navigation Not Working
- Make sure you're not in tmux copy mode
- Check if nvim is detected properly: In tmux, run:
  ```bash
  tmux display-message -p '#{pane_current_command}'
  ```
  It should show `nvim` or `vim` when in the editor

## How It Works

1. When you press `<C-h/j/k/l>` in tmux:
   - Tmux checks if the current pane is running vim/nvim
   - If yes, it sends the key to vim
   - If no, it performs tmux pane navigation

2. When you press `<C-h/j/k/l>` in nvim:
   - The vim-tmux-navigator plugin checks if there's a split in that direction
   - If yes, it navigates to the nvim split
   - If no, it tells tmux to navigate to the next pane

This creates a seamless experience where the boundary between tmux and nvim becomes invisible!