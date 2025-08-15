#!/usr/bin/env bash

# Install Tmux Plugin Manager (TPM) if not already installed
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    echo "TPM installed successfully!"
else
    echo "TPM is already installed."
fi

echo ""
echo "To complete the setup:"
echo "1. Start tmux"
echo "2. Press prefix + I (capital i) to install plugins"
echo "3. Reload tmux configuration: tmux source-file ~/.tmux.conf"