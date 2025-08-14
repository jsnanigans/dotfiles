# Centralized Rose Pine Theme Configuration

This directory contains the single source of truth for the Rose Pine theme used across all tools in the dotfiles.

## Overview

The Rose Pine theme is now centralized to ensure consistency across all tools and eliminate color definition duplication.

## Files

- `rose-pine.env` - Bash/shell environment variables for the theme
- `rose-pine.fish` - Fish shell specific theme configuration
- `tmux-rose-pine.conf` - Tmux theme configuration

## Color Palette

### Base Colors
- **Base**: `#191724` - Main background
- **Surface**: `#1f1d2e` - Secondary background (panels, sidebars)
- **Overlay**: `#26233a` - Tertiary background (popups, modals)
- **Highlight Low**: `#21202e` - Subtle highlights
- **Highlight Med**: `#403d52` - Medium highlights (selections)
- **Highlight High**: `#524f67` - Strong highlights (borders)

### Text Colors
- **Text**: `#e0def4` - Primary text
- **Subtle**: `#908caa` - Secondary text
- **Muted**: `#6e6a86` - Comments, disabled text

### Accent Colors
- **Love**: `#eb6f92` - Errors, important actions
- **Gold**: `#f6c177` - Warnings, highlights
- **Rose**: `#ebbcba` - Keywords, special elements
- **Pine**: `#31748f` - Functions, methods
- **Foam**: `#9ccfd8` - Strings, success states
- **Iris**: `#c4a7e7` - Variables, active elements

## Tool Integration

### Fish Shell
The Fish configuration automatically sources the theme from:
```fish
source ~/dotfiles/theme/rose-pine.fish
```

This sets all Fish colors and exports environment variables for other tools like FZF, bat, and delta.

### Tmux
Tmux sources the theme configuration from:
```tmux
source-file ~/dotfiles/theme/tmux-rose-pine.conf
```

### Neovim
Neovim already uses the rose-pine plugin and has a dedicated theme utility at:
`nvim/marvim/lua/utils/theme.lua`

### Ghostty
Ghostty is configured to use the built-in rose-pine theme:
```
theme = rose-pine
```

### Other Tools
- **FZF**: Uses colors exported by Fish/Bash environment
- **Bat**: Uses `BAT_THEME="rose-pine"` (configured in `bat/bat.conf`)
- **Delta**: Uses `DELTA_FEATURES="rose-pine"`
- **Lazygit**: Custom Rose Pine colors in `lazygit/config.yml`
- **Zellij**: Rose Pine theme defined and active in `zellij/config.kdl`
- **Yazi**: Uses default colors for file icons (intentionally kept for visibility)

## Usage

### In Shell Scripts
```bash
source ~/dotfiles/theme/rose-pine.env
echo "Using primary background: $ROSE_PINE_BASE"
```

### In Fish
```fish
source ~/dotfiles/theme/rose-pine.fish
echo "Using primary text: $ROSE_PINE_TEXT"
```

### View Available Colors
In Fish shell, run:
```fish
rose_pine_colors
```

This will display all Rose Pine colors with visual samples.

## Verification

Run the theme verification script to ensure all tools are using Rose Pine:
```bash
./theme/verify-theme.sh
```

This script checks:
- Tool configurations (Bat, Ghostty, Tmux, Zellij, Lazygit, Neovim)
- Environment variables (BAT_THEME, DELTA_FEATURES)
- Theme file existence

## Maintenance

When updating the theme:
1. Modify the color values in the appropriate theme file
2. Reload your shell configuration
3. Restart tmux for changes to take effect
4. Source the new theme in Neovim if needed
5. Run `./theme/verify-theme.sh` to confirm all tools are configured correctly

## Benefits

- **Single Source of Truth**: All color definitions in one place
- **Consistency**: Same colors across all tools
- **Maintainability**: Easy to update or switch themes
- **Documentation**: Clear color purpose and usage
- **Type Safety**: Semantic color mappings for different use cases