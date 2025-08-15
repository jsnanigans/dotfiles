#!/bin/bash

echo "Fixing Trouble icons in Neovim..."
echo ""

# Step 1: Clear Neovim cache
echo "Step 1: Clearing Neovim cache..."
rm -rf ~/.cache/nvim 2>/dev/null
rm -rf ~/.local/state/marvim 2>/dev/null

echo "Step 2: Testing in Neovim..."
cd ~/dotfiles/nvim/marvim

# Update plugins and clear compiled files
nvim --headless -c "lua require('lazy').sync()" -c "qa" 2>&1

echo ""
echo "Fix complete! Please:"
echo "1. Open Neovim"
echo "2. Run :Lazy sync"
echo "3. Restart Neovim"
echo "4. Run :source ~/dotfiles/nvim/debug-icons.lua to test"
echo "5. Open a file with errors and press <leader>xx to test Trouble"