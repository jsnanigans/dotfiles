#!/usr/bin/env fish

# Install Fisher (Fish plugin manager) if not already installed
if not functions -q fisher
    echo "Installing Fisher..."
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

echo "Installing Fish plugins..."

# Z - directory jumping (like zsh z plugin)
fisher install jethrokuan/z

# FZF integration
fisher install PatrickF1/fzf.fish

# Autopair - automatically insert closing brackets, quotes, etc.
fisher install jorgebucaran/autopair.fish

# Syntax highlighting 
# Note: Fish has built-in syntax highlighting!

# Autosuggestions (like zsh-autosuggestions)
# Note: Fish has this built-in! Just need to configure it

# Pure prompt (similar to robbyrussell but more minimal)
fisher install pure-fish/pure

# Bass - allows running bash scripts (needed for .env.sh)
fisher install edc/bass

echo "Fish plugins installed!"
echo ""
echo "Note: Fish has built-in autosuggestions. Configure with:"
echo "  set -U fish_autosuggestion_enabled 1"
echo "  set -U fish_color_autosuggestion brblack"