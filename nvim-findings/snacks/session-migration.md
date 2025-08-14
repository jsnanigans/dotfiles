# Session Migration: persistence.nvim → snacks.session

## Current Implementation Analysis

### persistence.nvim Configuration
- **Location**: `lua/config/plugins/core.lua:10-17`
- **Event**: `BufReadPre`
- **Config**: Default options `{}`

### Current Keybindings
```lua
-- Location: lua/config/keymaps/plugins.lua:8-30
<leader>qs - Restore Session (current directory)
<leader>ql - Restore Last Session
<leader>qd - Don't Save Current Session
```

## Snacks.session Features

### Advantages Over persistence.nvim
1. **Better Integration**: Native integration with other snacks components
2. **More Control**: Finer control over what gets saved
3. **Git Branch Awareness**: Can save sessions per git branch
4. **Autoload Options**: More sophisticated autoload conditions

### Feature Comparison

| Feature | persistence.nvim | snacks.session |
|---------|-----------------|----------------|
| Auto-save | ✅ | ✅ |
| Manual save | ✅ | ✅ |
| Directory-based sessions | ✅ | ✅ |
| Git branch sessions | ❌ | ✅ |
| Session picker UI | ❌ | ✅ |
| Custom save filters | Limited | ✅ |
| Hooks (pre/post save) | ❌ | ✅ |

## Migration Implementation

### Step 1: Remove persistence.nvim

```lua
-- lua/config/plugins/core.lua
-- Comment out or remove lines 10-17:
-- {
--   "folke/persistence.nvim",
--   event = "BufReadPre",
--   keys = function()
--     return require("config.keymaps").persistence_keys
--   end,
--   opts = {},
-- },
```

### Step 2: Add snacks.session Configuration

```lua
-- In your snacks.nvim config (lua/config/plugins/editor/snacks.lua or similar)
-- Add to the opts.session section:

session = {
  enabled = true,
  
  -- Autoload session for current directory
  autoload = {
    enabled = true,
    last = false, -- Load last session or current directory session
  },
  
  -- Autosave session on exit
  autosave = {
    enabled = true,
    on_exit = true,
  },
  
  -- What to save in sessions
  options = {
    "buffers",
    "curdir",
    "tabpages",
    "winsize",
    "help",
    "globals",
    "skiprtp",
    "folds",
  },
  
  -- Optional: Save sessions per git branch
  -- branch = true,
  
  -- Optional: Custom save path
  -- path = vim.fn.stdpath("data") .. "/sessions",
}
```

### Step 3: Update Keybindings

```lua
-- lua/config/keymaps/plugins.lua
-- Replace persistence_keys with:

M.snacks_session_keys = {
  {
    "<leader>qs",
    function()
      Snacks.session.load()
    end,
    desc = "Load Session",
  },
  {
    "<leader>ql",
    function()
      Snacks.session.load({ last = true })
    end,
    desc = "Load Last Session",
  },
  {
    "<leader>qS",
    function()
      Snacks.session.save()
    end,
    desc = "Save Session",
  },
  {
    "<leader>qd",
    function()
      Snacks.session.delete()
    end,
    desc = "Delete Session",
  },
  {
    "<leader>qq",
    function()
      Snacks.session.select()
    end,
    desc = "Select Session",
  },
}
```

### Step 4: Add Which-key Groups (Optional)

```lua
-- In which-key config
{
  ["<leader>q"] = { name = "+session" },
}
```

## Migration Script

```bash
#!/bin/bash
# Save this as migrate-session.sh

# Backup current session files
mkdir -p ~/.local/share/nvim/session_backup
cp -r ~/.local/share/nvim/sessions/* ~/.local/share/nvim/session_backup/ 2>/dev/null

echo "Session files backed up to ~/.local/share/nvim/session_backup"
echo "You can now safely test the new snacks.session configuration"
```

## Testing Checklist

- [ ] Sessions auto-save on exit
- [ ] Sessions auto-load on startup (if configured)
- [ ] Manual save works (`<leader>qS`)
- [ ] Session restore works (`<leader>qs`)
- [ ] Last session restore works (`<leader>ql`)
- [ ] Session picker UI works (`<leader>qq`)
- [ ] Old session files are compatible
- [ ] No errors on startup
- [ ] Performance is acceptable

## Rollback Plan

If issues arise:

1. Restore persistence.nvim configuration
2. Remove snacks.session configuration
3. Restore keybindings
4. Copy back session files from backup if needed

## Advanced Configuration

### Per-Branch Sessions

```lua
session = {
  branch = true, -- Save different sessions per git branch
  -- This is useful for switching between feature branches
}
```

### Custom Hooks

```lua
session = {
  hooks = {
    pre_save = function()
      -- Close all floating windows
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= "" then
          vim.api.nvim_win_close(win, false)
        end
      end
    end,
    
    post_load = function()
      -- Refresh file tree or other UI elements
      vim.cmd("NvimTreeRefresh")
    end,
  }
}
```

### Ignore Patterns

```lua
session = {
  ignore = {
    buftypes = { "terminal", "nofile" },
    filetypes = { "gitcommit", "gitrebase" },
    -- Ignore paths matching these patterns
    paths = { "*.tmp", "*.log" },
  }
}
```

## Notes

- Snacks.session stores sessions in the same location by default
- Session file format is compatible with vim's mksession
- The session picker provides a better UX for managing multiple sessions
- Consider enabling branch-based sessions for better workflow with git