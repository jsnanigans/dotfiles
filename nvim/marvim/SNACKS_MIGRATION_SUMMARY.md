# Snacks.nvim Migration Summary

## Quick Reference

### Plugins Being Replaced

| Old Plugin | Snacks Feature | Status |
|------------|---------------|---------|
| persistence.nvim | snacks.session | ✅ Full replacement |
| dressing.nvim | snacks.input | ✅ Full replacement |
| noice.nvim | snacks.notifier | ⚠️ Partial (no LSP UI) |
| lazygit.nvim | snacks.lazygit | ✅ Full replacement |
| flash.nvim | snacks.jump | ✅ Full replacement |
| todo-comments.nvim | snacks picker | ✅ Full replacement |
| dropbar.nvim | - | ❌ Keep (no equivalent) |
| which-key.nvim | snacks.toggle | ❌ Keep (only toggles) |

### New Keymaps

#### Session Management
- `<leader>qs` - Load session
- `<leader>ql` - Load last session  
- `<leader>qS` - Save session
- `<leader>qd` - Stop session

#### Notifications
- `<leader>sn` - Show notifications
- `<leader>snh` - Notification history
- `<leader>snc` - Clear notifications

#### LazyGit
- `<leader>gg` - Open LazyGit
- `<leader>gf` - LazyGit file history
- `<leader>gl` - LazyGit log

#### Navigation (Jump)
- `s` - Jump to character
- `S` - Jump with treesitter
- `gs` - Jump to word
- `gl` - Jump to line

#### TODO Comments
- `<leader>st` - Search all TODOs
- `<leader>sT` - Search FIXMEs only
- `]t` - Next TODO
- `[t` - Previous TODO

#### Toggles
- `<leader>ud` - Toggle diagnostics
- `<leader>uw` - Toggle wrap
- `<leader>us` - Toggle spell
- `<leader>un` - Toggle line numbers
- `<leader>ur` - Toggle relative numbers

## Migration Steps

### Automatic Migration
```bash
# Run the migration script
./scripts/migrate-to-snacks.sh
```

### Manual Migration

1. **Update snacks.nvim config** (`lua/config/plugins/editor/snacks.lua`)
   - Copy content from `snacks-full.lua`

2. **Comment out old plugins**:
   - `lua/config/plugins/core.lua` - Comment persistence.nvim, dressing.nvim
   - `lua/config/plugins/ui/notifications.lua` - Comment noice.nvim
   - `lua/config/plugins/git.lua` - Comment lazygit.nvim
   - `lua/config/plugins/editor.lua` - Comment flash.nvim
   - `lua/config/plugins/coding.lua` - Comment todo-comments.nvim

3. **Update keymaps** in `lua/config/keymaps.lua`:
   - Import snacks keymaps: `local snacks_keys = require("config.keymaps.snacks")`
   - Replace old keymap references with snacks versions

4. **Sync plugins**:
   ```vim
   :Lazy sync
   ```

5. **Clean unused plugins**:
   ```vim
   :Lazy clean
   ```

## Testing Checklist

- [ ] **Sessions**: Create, save, load, stop sessions
- [ ] **Input**: Test vim.ui.input prompts (rename, create file)
- [ ] **Notifications**: Test vim.notify, check history
- [ ] **LazyGit**: Open main view, file history, log
- [ ] **Jump**: Test s/S navigation in normal/visual/operator modes
- [ ] **TODOs**: Search and navigate TODO comments
- [ ] **Toggles**: Test all toggle keymaps

## Rollback

If issues occur:
```bash
# Restore from backup (created by migration script)
cp -r ~/dotfiles/nvim/marvim/backups/pre-snacks-*/* ~/dotfiles/nvim/marvim/

# Or restore individual files
cp ~/dotfiles/nvim/marvim/lua/config/plugins/core-old.lua ~/dotfiles/nvim/marvim/lua/config/plugins/core.lua
```

## Benefits

1. **Single Plugin**: Reduces plugin count from 8 to 1
2. **Consistent API**: All features use the same snacks API
3. **Better Performance**: Single plugin initialization
4. **Active Development**: Snacks.nvim is actively maintained by folke
5. **Integrated Features**: Features work well together

## Limitations

1. **Noice LSP UI**: Advanced LSP UI features not available
2. **Breadcrumbs**: No direct dropbar replacement
3. **Which-key**: Only toggle mappings, not full keymap discovery

## Future Considerations

- Monitor snacks.nvim for new features
- Consider snacks.winbar when available for breadcrumbs
- Evaluate snacks.dashboard if needed
- Watch for snacks.lsp improvements