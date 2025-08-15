#!/usr/bin/env bash

# Theme switcher script
# Usage: ./switch-theme.sh [theme-name]
# Available themes: github-dark-colorblind, flexoki-dark, rose-pine

set -e

THEME="${1:-github-dark-colorblind}"
DOTFILES_DIR="$HOME/dotfiles"
THEME_DIR="$DOTFILES_DIR/theme"

case "$THEME" in
  "github-dark-colorblind"|"github")
    THEME_NAME="github-dark-colorblind"
    THEME_ENV="$THEME_DIR/github-dark-colorblind.env"
    THEME_FISH="$THEME_DIR/github-dark-colorblind.fish"
    THEME_TMUX="$THEME_DIR/tmux-github-dark-colorblind.conf"
    THEME_YAZI="$DOTFILES_DIR/yazi/theme-github-dark-colorblind.toml"
    BAT_THEME="GitHub Dark"
    ;;
  "flexoki-dark"|"flexoki")
    THEME_NAME="flexoki-dark"
    THEME_ENV="$THEME_DIR/flexoki-dark.env"
    THEME_FISH="$THEME_DIR/flexoki-dark.fish"
    THEME_TMUX="$THEME_DIR/tmux-flexoki-dark.conf"
    THEME_YAZI="$DOTFILES_DIR/yazi/theme.toml"
    BAT_THEME="TwoDark"
    ;;
  "rose-pine"|"rose")
    THEME_NAME="rose-pine"
    THEME_ENV="$THEME_DIR/rose-pine.env"
    THEME_FISH="$THEME_DIR/rose-pine.fish"
    THEME_TMUX="$THEME_DIR/tmux-rose-pine.conf"
    THEME_YAZI="$DOTFILES_DIR/yazi/theme.toml"
    BAT_THEME="rose-pine"
    ;;
  *)
    echo "Unknown theme: $THEME"
    echo "Available themes: github-dark-colorblind, flexoki-dark, rose-pine"
    exit 1
    ;;
esac

echo "Switching to $THEME_NAME theme..."

# Update Fish shell colors
if [ -f "$THEME_FISH" ]; then
  echo "Applying Fish shell colors..."
  fish -c "source $THEME_FISH"
fi

# Update tmux theme
if [ -f "$THEME_TMUX" ]; then
  echo "Updating tmux theme..."
  ln -sf "$THEME_TMUX" "$DOTFILES_DIR/tmux/theme.conf"
  tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true
fi

# Update Yazi theme
if [ -f "$THEME_YAZI" ]; then
  echo "Updating Yazi theme..."
  ln -sf "$THEME_YAZI" "$DOTFILES_DIR/yazi/theme.toml"
fi

# Update bat theme
echo "Updating bat theme..."
sed -i.bak "s/--theme=\".*\"/--theme=\"$BAT_THEME\"/" "$DOTFILES_DIR/bat/bat.conf"
rm "$DOTFILES_DIR/bat/bat.conf.bak"

# Export environment variables for current shell
if [ -f "$THEME_ENV" ]; then
  source "$THEME_ENV"
fi

# Create a marker file for the current theme
echo "$THEME_NAME" > "$THEME_DIR/.current-theme"

echo "✓ Theme switched to $THEME_NAME"
echo ""
echo "To apply the theme in Neovim, add this to your config:"
echo "  vim.cmd('colorscheme $THEME_NAME')"
echo ""
echo "Or set in your Neovim config to auto-detect:"
echo "  local theme = vim.fn.readfile(vim.fn.expand('~/dotfiles/theme/.current-theme'))[1]"
echo "  vim.cmd('colorscheme ' .. theme)"