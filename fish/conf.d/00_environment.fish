# Core environment variables that need to be set early
# This file loads before path configuration

# Dotfiles location
set -gx DOTFILES $HOME/dotfiles

# Default shell behavior
set -gx FISH_LAUNCHED_FROM_TMUX 1