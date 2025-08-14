#!/bin/bash

# Migration script for snacks.nvim
# This script helps migrate from multiple plugins to snacks.nvim

set -e

NVIM_CONFIG_DIR="$HOME/dotfiles/nvim/marvim"
BACKUP_DIR="$NVIM_CONFIG_DIR/backups/pre-snacks-$(date +%Y%m%d-%H%M%S)"

echo "🍿 Snacks.nvim Migration Script"
echo "==============================="
echo ""

# Create backup
echo "📦 Creating backup at: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Backup important files
cp -r "$NVIM_CONFIG_DIR/lua" "$BACKUP_DIR/"
cp "$NVIM_CONFIG_DIR/lazy-lock.json" "$BACKUP_DIR/" 2>/dev/null || true
cp "$NVIM_CONFIG_DIR/init.lua" "$BACKUP_DIR/"

echo "✅ Backup created successfully"
echo ""

# Ask for confirmation
echo "This script will:"
echo "  1. Replace persistence.nvim with snacks.session"
echo "  2. Replace dressing.nvim with snacks.input"
echo "  3. Replace noice.nvim with snacks.notifier"
echo "  4. Replace lazygit.nvim with snacks.lazygit"
echo "  5. Replace flash.nvim with snacks.jump"
echo "  6. Replace todo-comments.nvim with snacks picker patterns"
echo "  7. Update all related keymaps"
echo ""
read -p "Do you want to proceed? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Migration cancelled"
    exit 1
fi

echo ""
echo "🔄 Starting migration..."

# Step 1: Update snacks.nvim configuration
echo "  1. Updating snacks.nvim configuration..."
if [ -f "$NVIM_CONFIG_DIR/lua/config/plugins/editor/snacks-full.lua" ]; then
    mv "$NVIM_CONFIG_DIR/lua/config/plugins/editor/snacks.lua" "$NVIM_CONFIG_DIR/lua/config/plugins/editor/snacks-old.lua"
    mv "$NVIM_CONFIG_DIR/lua/config/plugins/editor/snacks-full.lua" "$NVIM_CONFIG_DIR/lua/config/plugins/editor/snacks.lua"
    echo "     ✅ Snacks configuration updated"
else
    echo "     ⚠️  snacks-full.lua not found, skipping"
fi

# Step 2: Update plugin files
echo "  2. Updating plugin configurations..."

# Core plugins
if [ -f "$NVIM_CONFIG_DIR/lua/config/plugins/core-migrated.lua" ]; then
    mv "$NVIM_CONFIG_DIR/lua/config/plugins/core.lua" "$NVIM_CONFIG_DIR/lua/config/plugins/core-old.lua"
    mv "$NVIM_CONFIG_DIR/lua/config/plugins/core-migrated.lua" "$NVIM_CONFIG_DIR/lua/config/plugins/core.lua"
    echo "     ✅ Core plugins updated"
fi

# Editor plugins
if [ -f "$NVIM_CONFIG_DIR/lua/config/plugins/editor-migrated.lua" ]; then
    mv "$NVIM_CONFIG_DIR/lua/config/plugins/editor.lua" "$NVIM_CONFIG_DIR/lua/config/plugins/editor-old.lua"
    mv "$NVIM_CONFIG_DIR/lua/config/plugins/editor-migrated.lua" "$NVIM_CONFIG_DIR/lua/config/plugins/editor.lua"
    echo "     ✅ Editor plugins updated"
fi

# Git plugins
if [ -f "$NVIM_CONFIG_DIR/lua/config/plugins/git-migrated.lua" ]; then
    mv "$NVIM_CONFIG_DIR/lua/config/plugins/git.lua" "$NVIM_CONFIG_DIR/lua/config/plugins/git-old.lua"
    mv "$NVIM_CONFIG_DIR/lua/config/plugins/git-migrated.lua" "$NVIM_CONFIG_DIR/lua/config/plugins/git.lua"
    echo "     ✅ Git plugins updated"
fi

# Coding plugins
if [ -f "$NVIM_CONFIG_DIR/lua/config/plugins/coding-migrated.lua" ]; then
    mv "$NVIM_CONFIG_DIR/lua/config/plugins/coding.lua" "$NVIM_CONFIG_DIR/lua/config/plugins/coding-old.lua"
    mv "$NVIM_CONFIG_DIR/lua/config/plugins/coding-migrated.lua" "$NVIM_CONFIG_DIR/lua/config/plugins/coding.lua"
    echo "     ✅ Coding plugins updated"
fi

# UI plugins
if [ -f "$NVIM_CONFIG_DIR/lua/config/plugins/ui-migrated.lua" ]; then
    mv "$NVIM_CONFIG_DIR/lua/config/plugins/ui.lua" "$NVIM_CONFIG_DIR/lua/config/plugins/ui-old.lua"
    mv "$NVIM_CONFIG_DIR/lua/config/plugins/ui-migrated.lua" "$NVIM_CONFIG_DIR/lua/config/plugins/ui.lua"
    echo "     ✅ UI plugins updated"
fi

# Step 3: Update keymaps
echo "  3. Updating keymaps..."
# This would need to be done manually or with more complex sed commands
echo "     ⚠️  Keymaps need manual update - see snacks.lua for new keymaps"

echo ""
echo "🎉 Migration completed!"
echo ""
echo "Next steps:"
echo "  1. Open Neovim and run :Lazy sync"
echo "  2. Test all migrated features"
echo "  3. If everything works, you can remove the backup: rm -rf $BACKUP_DIR"
echo "  4. If issues occur, restore from backup: cp -r $BACKUP_DIR/* $NVIM_CONFIG_DIR/"
echo ""
echo "Features to test:"
echo "  - Session management: <leader>qs, <leader>ql, <leader>qS"
echo "  - Notifications: <leader>sn, <leader>snh, <leader>snc"
echo "  - LazyGit: <leader>gg, <leader>gf, <leader>gl"
echo "  - Jump navigation: s, S (in normal/visual mode)"
echo "  - TODO search: <leader>st, <leader>sT, ]t, [t"
echo "  - Toggles: <leader>ud, <leader>uw, <leader>us"
echo ""
echo "📝 See SNACKS_MIGRATION_PLAN.md for detailed documentation"