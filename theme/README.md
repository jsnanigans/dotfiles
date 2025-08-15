# Centralized Flexoki Dark Theme Configuration

This directory contains the single source of truth for the Flexoki Dark theme used across all tools in the dotfiles.

## Overview

The Flexoki Dark theme is now centralized to ensure consistency across all tools and eliminate color definition duplication.

## Files

- `flexoki-dark.env` - Bash/shell environment variables for the theme
- `flexoki-dark.fish` - Fish shell specific theme configuration
- `tmux-flexoki-dark.conf` - Tmux theme configuration

## Color Palette

### Base Colors (ANSI 16-color mapping)
- **Black** (0): `#100f0f` - Background
- **Red** (1): `#d14d41` - Errors, important
- **Green** (2): `#879a39` - Success, strings
- **Yellow** (3): `#d0a215` - Warnings
- **Blue** (4): `#4385be` - Functions, primary
- **Magenta** (5): `#ce5d97` - Keywords, special
- **Cyan** (6): `#3aa99f` - Links, secondary
- **White** (7): `#878580` - Comments, muted

### Bright Colors
- **Bright Black** (8): `#575653` - Borders, subtle
- **Bright Red** (9): `#af3029` - Strong errors
- **Bright Green** (10): `#66800b` - Strong success
- **Bright Yellow** (11): `#ad8301` - Strong warnings
- **Bright Blue** (12): `#205ea6` - Strong primary
- **Bright Magenta** (13): `#a02f6f` - Strong special
- **Bright Cyan** (14): `#24837b` - Strong secondary
- **Bright White** (15): `#cecdc3` - Foreground text

### Theme Colors
- **Background**: `#100f0f` - Main background
- **Foreground**: `#cecdc3` - Primary text
- **Cursor**: `#cecdc3` - Cursor color
- **Cursor Text**: `#100f0f` - Text under cursor
- **Selection Background**: `#cecdc3` - Selection highlight
- **Selection Foreground**: `#100f0f` - Text in selection

## Tool Integration

### Fish Shell
The Fish configuration automatically sources the theme from:
```fish
source ~/dotfiles/theme/flexoki-dark.fish
```

This sets all Fish colors and exports environment variables for other tools like FZF, bat, and delta.

### Tmux
Tmux sources the theme configuration from:
```tmux
source-file ~/dotfiles/theme/tmux-flexoki-dark.conf
```

### Neovim
Neovim can be configured to use the flexoki-dark colorscheme if available.

### Ghostty
Ghostty uses the inline flexoki-dark color palette configuration:
```
palette = 0=#100f0f
palette = 1=#d14d41
# ... etc
background = #100f0f
foreground = #cecdc3
```

### Other Tools
- **FZF**: Uses colors exported by Fish/Bash environment
- **Bat**: Configure with `BAT_THEME="flexoki-dark"` if theme is available
- **Delta**: Configure with `DELTA_FEATURES="flexoki-dark"` if theme is available
- **Lazygit**: Custom Flexoki Dark colors can be configured
- **Zellij**: Flexoki Dark theme can be configured
- **Yazi**: Uses theme colors for file display

## Usage

### In Shell Scripts
```bash
source ~/dotfiles/theme/flexoki-dark.env
echo "Using background: $FLEXOKI_BACKGROUND"
```

### In Fish
```fish
source ~/dotfiles/theme/flexoki-dark.fish
echo "Using foreground: $FLEXOKI_BRIGHT_WHITE"
```

## Verification

Run the theme verification script to ensure all tools are using Flexoki Dark:
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
4. Restart Ghostty to apply the new colors
5. Run `./theme/verify-theme.sh` to confirm all tools are configured correctly

## Benefits

- **Single Source of Truth**: All color definitions in one place
- **Consistency**: Same colors across all tools
- **Maintainability**: Easy to update or switch themes
- **Documentation**: Clear color purpose and usage
- **Type Safety**: Semantic color mappings for different use cases