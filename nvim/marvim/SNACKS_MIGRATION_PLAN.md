# Snacks.nvim Migration Plan

## Overview
This document outlines the complete migration from various plugins to snacks.nvim features.

## Migration Roadmap

### 1. Session Management: persistence.nvim → snacks.session

**Current Setup:**
- Plugin: `folke/persistence.nvim`
- Location: `lua/config/plugins/core.lua`
- Keymaps in: `lua/config/keymaps/plugins.lua`

**Migration Steps:**
```lua
-- In snacks.lua config, add:
session = {
  enabled = true,
  autoload = true,
  autosave = true,
  options = { "buffers", "curdir", "globals", "help", "tabpages", "winsize" },
}
```

**Keymap Changes:**
```lua
-- Old keymaps (persistence.nvim):
{ "<leader>qs", function() require("persistence").load() end }
{ "<leader>ql", function() require("persistence").load({ last = true }) end }
{ "<leader>qd", function() require("persistence").stop() end }

-- New keymaps (snacks.session):
{ "<leader>qs", function() require("snacks").session.load() end }
{ "<leader>ql", function() require("snacks").session.load({ last = true }) end }
{ "<leader>qd", function() require("snacks").session.stop() end }
{ "<leader>qS", function() require("snacks").session.save() end }
```

### 2. UI Input: dressing.nvim → snacks.input

**Current Setup:**
- Plugin: `stevearc/dressing.nvim`
- Already have snacks.input enabled

**Migration Steps:**
```lua
-- In snacks.lua config, ensure:
input = {
  enabled = true,
  win = {
    relative = "cursor",
    row = 1,
    col = 0,
    width = 60,
    height = 1,
    border = "rounded",
  },
}
```

**Note:** Since snacks.input is already enabled, just need to remove dressing.nvim.

### 3. Notifications: noice.nvim → snacks.notifier

**Current Setup:**
- Plugin: `folke/noice.nvim`
- Location: `lua/config/plugins/ui/notifications.lua`
- Complex configuration with LSP overrides

**Migration Steps:**
```lua
-- In snacks.lua config, add:
notifier = {
  enabled = true,
  timeout = 3000,
  width = { min = 40, max = 0.4 },
  height = { min = 1, max = 0.6 },
  margin = { top = 0, right = 1, bottom = 0 },
  padding = true,
  sort = { "added" },
  icons = {
    error = " ",
    warn = " ",
    info = " ",
    debug = " ",
    trace = " ",
  },
  style = "compact",
}
```

**Keymap Changes:**
```lua
-- Old keymaps (noice.nvim):
{ "<leader>sn", "", desc = "+noice" }
{ "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end }
{ "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end }

-- New keymaps (snacks.notifier):
{ "<leader>sn", function() require("snacks").notifier.show() end }
{ "<leader>snh", function() require("snacks").notifier.history() end }
{ "<leader>snc", function() require("snacks").notifier.clear() end }
```

**Note:** LSP hover/signature help scrolling needs alternative solution (keep noice for now or use native).

### 4. Git UI: lazygit.nvim → snacks.lazygit

**Current Setup:**
- Plugin: `kdheepak/lazygit.nvim`
- Location: `lua/config/plugins/git.lua`

**Migration Steps:**
```lua
-- In snacks.lua config, add:
lazygit = {
  enabled = true,
  win = {
    width = 0.9,
    height = 0.9,
    border = "rounded",
  },
}
```

**Keymap Changes:**
```lua
-- Old keymap:
{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }

-- New keymap:
{ "<leader>gg", function() require("snacks").lazygit.open() end, desc = "LazyGit" }
{ "<leader>gf", function() require("snacks").lazygit.file() end, desc = "LazyGit File" }
{ "<leader>gl", function() require("snacks").lazygit.log() end, desc = "LazyGit Log" }
```

### 5. Navigation: flash.nvim → snacks.jump + snacks.scope

**Current Setup:**
- Plugin: `folke/flash.nvim`
- Location: `lua/config/plugins/editor.lua`

**Migration Steps:**
```lua
-- In snacks.lua config, add:
scope = {
  enabled = true,  -- Already enabled
  cursor = true,
  textobjects = true,
  treesitter = true,
},
jump = {
  enabled = true,
  mode = "default",
  reverse = false,
  wrap = true,
  multi_windows = false,
  keys = {
    next = ";",
    prev = ",",
  },
}
```

**Keymap Changes:**
```lua
-- Old keymaps (flash.nvim):
{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end }
{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end }
{ "r", mode = "o", function() require("flash").remote() end }
{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end }
{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end }

-- New keymaps (snacks.jump):
{ "s", mode = { "n", "x", "o" }, function() require("snacks").jump.jump() end }
{ "S", mode = { "n", "x", "o" }, function() require("snacks").jump.jump({ treesitter = true }) end }
```

### 6. TODO Comments: todo-comments.nvim → snacks picker patterns

**Current Setup:**
- Plugin: `folke/todo-comments.nvim`
- Location: `lua/config/plugins/coding.lua`

**Migration Steps:**
Already using snacks picker for TODO search:
```lua
-- Current implementation in keymaps:
require("snacks").picker.grep({ pattern = "TODO|HACK|PERF|NOTE|FIX|FIXME" })
```

**Enhanced Configuration:**
```lua
-- In snacks.lua config, add custom picker preset:
picker = {
  -- existing config...
  presets = {
    todos = {
      prompt_title = "Todo Comments",
      finder = "grep",
      pattern = "TODO|HACK|PERF|NOTE|FIX|FIXME|WARNING",
      flags = "--case-sensitive",
    },
  },
}
```

**Keymap Updates:**
```lua
-- Update existing keymaps to use preset:
{ "<leader>st", function() require("snacks").picker.pick("todos") end }
{ "<leader>sT", function() require("snacks").picker.pick("todos", { pattern = "TODO|FIX|FIXME" }) end }
```

### 7. Breadcrumbs: dropbar.nvim → snacks.statuscolumn

**Current Setup:**
- Plugin: `Bekaboo/dropbar.nvim`
- Location: `lua/config/plugins/ui/breadcrumbs.lua`
- Complex configuration with custom sources

**Note:** This is the most complex migration. Snacks.statuscolumn provides different functionality than dropbar's breadcrumbs. Consider keeping dropbar for now or using snacks.winbar when available.

## Complete Snacks Configuration

```lua
-- lua/config/plugins/editor/snacks.lua
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Existing picker config
      picker = {
        enabled = true,
        sources = {
          -- existing grep and files config
        },
        layout = {
          preset = "ivy",
        },
        presets = {
          todos = {
            prompt_title = "Todo Comments",
            finder = "grep",
            pattern = "TODO|HACK|PERF|NOTE|FIX|FIXME|WARNING",
            flags = "--case-sensitive",
          },
        },
      },
      
      -- Session management (replaces persistence.nvim)
      session = {
        enabled = true,
        autoload = false,  -- Don't autoload on startup
        autosave = true,
        options = { "buffers", "curdir", "globals", "help", "tabpages", "winsize" },
      },
      
      -- Input UI (replaces dressing.nvim)
      input = {
        enabled = true,
        win = {
          relative = "cursor",
          row = 1,
          col = 0,
          width = 60,
          height = 1,
          border = "rounded",
        },
      },
      
      -- Notifications (replaces noice.nvim)
      notifier = {
        enabled = true,
        timeout = 3000,
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true,
        sort = { "added" },
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          debug = " ",
          trace = " ",
        },
        style = "compact",
      },
      
      -- LazyGit integration (replaces lazygit.nvim)
      lazygit = {
        enabled = true,
        win = {
          width = 0.9,
          height = 0.9,
          border = "rounded",
        },
      },
      
      -- Scope indication (part of flash replacement)
      scope = {
        enabled = true,
        cursor = true,
        textobjects = true,
        treesitter = true,
      },
      
      -- Jump navigation (replaces flash.nvim)
      jump = {
        enabled = true,
        mode = "default",
        reverse = false,
        wrap = true,
        multi_windows = false,
        keys = {
          next = ";",
          prev = ",",
        },
      },
    },
    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)
    end,
  },
}
```

## Keymap Updates Summary

Create new file: `lua/config/keymaps/snacks.lua`

```lua
local M = {}

-- Session management (replaces persistence)
M.session_keys = {
  { "<leader>qs", function() require("snacks").session.load() end, desc = "Load Session" },
  { "<leader>ql", function() require("snacks").session.load({ last = true }) end, desc = "Load Last Session" },
  { "<leader>qd", function() require("snacks").session.stop() end, desc = "Stop Session" },
  { "<leader>qS", function() require("snacks").session.save() end, desc = "Save Session" },
}

-- Notifications (replaces noice)
M.notifier_keys = {
  { "<leader>sn", function() require("snacks").notifier.show() end, desc = "Show Notifications" },
  { "<leader>snh", function() require("snacks").notifier.history() end, desc = "Notification History" },
  { "<leader>snc", function() require("snacks").notifier.clear() end, desc = "Clear Notifications" },
}

-- Git UI (replaces lazygit)
M.lazygit_keys = {
  { "<leader>gg", function() require("snacks").lazygit.open() end, desc = "LazyGit" },
  { "<leader>gf", function() require("snacks").lazygit.file() end, desc = "LazyGit File" },
  { "<leader>gl", function() require("snacks").lazygit.log() end, desc = "LazyGit Log" },
}

-- Navigation (replaces flash)
M.jump_keys = {
  { "s", mode = { "n", "x", "o" }, function() require("snacks").jump.jump() end, desc = "Jump" },
  { "S", mode = { "n", "x", "o" }, function() require("snacks").jump.jump({ treesitter = true }) end, desc = "Jump Treesitter" },
}

-- TODO Comments (enhanced)
M.todo_keys = {
  { "<leader>st", function() require("snacks").picker.pick("todos") end, desc = "Search TODOs" },
  { "<leader>sT", function() require("snacks").picker.pick("todos", { pattern = "TODO|FIX|FIXME" }) end, desc = "Search FIXMEs" },
  { "]t", function() require("snacks").picker.next("todos") end, desc = "Next TODO" },
  { "[t", function() require("snacks").picker.prev("todos") end, desc = "Previous TODO" },
}

return M
```

## Plugins to Remove

After successful migration, remove from lazy-lock.json and configs:
1. `persistence.nvim` - Remove from `lua/config/plugins/core.lua`
2. `dressing.nvim` - Remove from `lua/config/plugins/core.lua`
3. `noice.nvim` - Remove from `lua/config/plugins/ui/notifications.lua`
4. `lazygit.nvim` - Remove from `lua/config/plugins/git.lua`
5. `flash.nvim` - Remove from `lua/config/plugins/editor.lua`
6. `todo-comments.nvim` - Remove from `lua/config/plugins/coding.lua`

## Testing Checklist

- [ ] Session saving and loading works
- [ ] Input prompts display correctly
- [ ] Notifications appear and can be cleared
- [ ] LazyGit opens and functions properly
- [ ] Jump navigation works in all modes
- [ ] TODO comment search and navigation works
- [ ] All keymaps are functional
- [ ] No plugin conflicts
- [ ] Performance is acceptable

## Rollback Plan

If issues arise:
1. Restore from backup
2. Remove snacks features one by one to identify issues
3. Keep both old and new plugins temporarily with different keymaps

## Notes

- **Dropbar Alternative**: Snacks doesn't have a direct breadcrumb replacement. Consider keeping dropbar or waiting for snacks.winbar.
- **Which-key**: Not migrating as snacks.toggle only handles toggle mappings, not full keymap discovery.
- **Noice LSP Features**: Some advanced LSP UI features from noice might be lost. Consider keeping noice for LSP UI only.