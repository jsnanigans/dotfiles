# MARVIM Framework Migration Guide

This guide documents the migration from the old pattern-based configuration to the new MARVIM framework architecture.

## Table of Contents

- [Overview](#overview)
- [Migration Patterns](#migration-patterns)
- [API Reference](#api-reference)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Breaking Changes](#breaking-changes)

## Overview

The MARVIM framework introduces a unified architecture that eliminates code duplication and provides consistent patterns across the entire configuration. The migration consolidates:

- **20+ pcall patterns** → Single `module.load()` API
- **34 autocmd instances** → Centralized autocmd manager
- **Scattered utilities** → Unified framework modules
- **Ad-hoc error handling** → Consistent error resilience

## Migration Patterns

### Module Loading

#### Old Pattern
```lua
-- Scattered throughout files
local status_ok, module = pcall(require, "some.module")
if not status_ok then
  vim.notify("Failed to load module: " .. module, vim.log.levels.ERROR)
  return
end

-- Or worse, no error handling
local module = require("some.module")
```

#### New Pattern
```lua
local M = require("marvim.module")

-- Safe loading with automatic caching
local module = M.load("some.module")
if not module then
  return -- Error already handled and logged
end

-- Or with callback for deferred loading
M.on_load("telescope", function(telescope)
  telescope.setup({ ... })
end)
```

### Configuration Management

#### Old Pattern
```lua
-- In each plugin file
local config = {
  option1 = true,
  option2 = "value"
}

-- Manual merging
if user_config then
  config = vim.tbl_extend("force", config, user_config)
end
```

#### New Pattern
```lua
local config = require("marvim.config")

-- Define schema with defaults
config.define("plugin_name", {
  option1 = { default = true, type = "boolean" },
  option2 = { default = "value", type = "string" }
})

-- Get merged configuration
local opts = config.get("plugin_name")
```

### Autocmd Management

#### Old Pattern
```lua
-- Scattered across files
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.lua",
  callback = function() ... end
})

-- Manual group management
local group = vim.api.nvim_create_augroup("MyGroup", { clear = true })
```

#### New Pattern
```lua
local autocmd = require("marvim.autocmd")

-- Create managed group
local group = autocmd.group("MyPlugin", { clear = true })

-- Add autocmd with automatic error handling
autocmd.create("BufEnter", {
  group = group,
  pattern = "*.lua",
  callback = function() ... end,
  desc = "Handle Lua files"
})
```

### Event System

#### Old Pattern
```lua
-- No inter-module communication
-- Modules directly call each other
local lsp = require("config.plugins.lsp")
lsp.on_attach(client, bufnr)
```

#### New Pattern
```lua
local event = require("marvim.event")

-- Publisher
event.emit("LspAttach", client, bufnr)

-- Subscriber
event.on("LspAttach", function(client, bufnr)
  -- Handle event
end)
```

### Feature Toggles

#### Old Pattern
```lua
-- Ad-hoc toggle logic
local diagnostics_enabled = true
vim.keymap.set("n", "<leader>td", function()
  diagnostics_enabled = not diagnostics_enabled
  if diagnostics_enabled then
    vim.diagnostic.enable()
  else
    vim.diagnostic.disable()
  end
end)
```

#### New Pattern
```lua
local toggle = require("marvim.toggle")

-- Register toggle with proper state management
toggle.register("diagnostics", {
  on = vim.diagnostic.enable,
  off = vim.diagnostic.disable,
  status = vim.diagnostic.is_enabled
})

-- Use anywhere
toggle.toggle("diagnostics")
```

### Plugin Configuration

#### Old Pattern
```lua
return {
  "plugin/name",
  config = function()
    local status_ok, plugin = pcall(require, "plugin")
    if not status_ok then
      return
    end
    plugin.setup({ ... })
  end
}
```

#### New Pattern
```lua
local plugin = require("marvim.plugin")

return plugin.spec("plugin/name", {
  config = plugin.config("plugin", {
    -- Configuration options
  }),
  -- Automatic error handling and lazy loading
})
```

## API Reference

### Core Modules

#### `marvim.module`
```lua
-- Load module safely with caching
local mod = module.load("module.name")

-- Deferred loading with callback
module.on_load("module.name", function(mod)
  -- Use module
end)

-- Check if module is available
if module.is_available("module.name") then
  -- Module can be loaded
end

-- Invalidate cache
module.invalidate("module.name")
```

#### `marvim.config`
```lua
-- Define configuration schema
config.define("feature", {
  option = { default = "value", type = "string", required = false }
})

-- Get configuration
local opts = config.get("feature")

-- Set configuration
config.set("feature", { option = "new_value" })

-- Merge configuration
config.merge("feature", { additional = true })
```

#### `marvim.autocmd`
```lua
-- Create autocmd group
local group = autocmd.group("GroupName", { clear = true })

-- Create autocmd
autocmd.create("Event", {
  group = group,
  pattern = "pattern",
  callback = function() end,
  desc = "Description"
})

-- Clear group
autocmd.clear(group)

-- List groups
local groups = autocmd.list_groups()
```

#### `marvim.event`
```lua
-- Subscribe to event
local unsubscribe = event.on("EventName", function(...)
  -- Handle event
end)

-- Emit event
event.emit("EventName", arg1, arg2)

-- One-time listener
event.once("EventName", function(...) end)

-- Unsubscribe
unsubscribe()

-- Get all listeners
local listeners = event.get_listeners()
```

#### `marvim.toggle`
```lua
-- Register toggle
toggle.register("feature", {
  on = function() end,
  off = function() end,
  status = function() return boolean end
})

-- Toggle feature
toggle.toggle("feature")

-- Set specific state
toggle.set("feature", true)

-- Get state
local state = toggle.state("feature")

-- List all toggles
local toggles = toggle.list()
```

#### `marvim.cache`
```lua
-- Set cache entry
cache.set("key", value, ttl_ms)

-- Get cache entry
local value = cache.get("key")

-- Invalidate entry
cache.invalidate("key")

-- Clear entire cache
cache.clear()

-- Get statistics
local stats = cache.stats()
```

#### `marvim.utils`
```lua
-- Table utilities
utils.tbl_deep_merge(t1, t2)
utils.tbl_filter(tbl, predicate)
utils.tbl_map(tbl, fn)

-- String utilities
utils.str_split(str, delimiter)
utils.str_trim(str)
utils.str_starts_with(str, prefix)

-- Path utilities
utils.path_join(...)
utils.path_exists(path)
utils.path_is_file(path)
utils.path_is_dir(path)

-- Function utilities
utils.debounce(fn, ms)
utils.throttle(fn, ms)
utils.once(fn)
```

## Examples

### Complete Plugin Migration

#### Before
```lua
-- lua/config/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local status_ok, telescope = pcall(require, "telescope")
    if not status_ok then
      vim.notify("Failed to load telescope", vim.log.levels.ERROR)
      return
    end

    local actions_ok, actions = pcall(require, "telescope.actions")
    if not actions_ok then
      return
    end

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = actions.close
          }
        }
      }
    })

    -- Load extensions
    pcall(telescope.load_extension, "fzf")
  end
}
```

#### After
```lua
-- lua/config/plugins/telescope.lua
local M = require("marvim.module")
local plugin = require("marvim.plugin")
local config = require("marvim.config")

-- Define configuration schema
config.define("telescope", {
  fzf_extension = { default = true, type = "boolean" }
})

return plugin.spec("nvim-telescope/telescope.nvim", {
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = M.load("telescope")
    local actions = M.load("telescope.actions")

    if not telescope or not actions then
      return
    end

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = actions.close
          }
        }
      }
    })

    -- Conditionally load extensions based on config
    local opts = config.get("telescope")
    if opts.fzf_extension then
      M.on_load("telescope", function(t)
        t.load_extension("fzf")
      end)
    end
  end
})
```

### LSP Configuration Migration

#### Before
```lua
-- lua/config/plugins/lsp/config.lua
local M = {}

function M.on_attach(client, bufnr)
  -- Setup keymaps
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
  -- More keymaps...

  -- Setup autocmds
  if client.supports_method("textDocument/documentHighlight") then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
  end
end

return M
```

#### After
```lua
-- lua/config/plugins/lsp/config.lua
local M = {}
local event = require("marvim.event")
local autocmd = require("marvim.autocmd")

function M.on_attach(client, bufnr)
  -- Emit event for other modules to hook into
  event.emit("LspAttach", client, bufnr)

  -- Setup autocmds with proper group management
  local group = autocmd.group("LspBuffer_" .. bufnr, { clear = true })

  if client.supports_method("textDocument/documentHighlight") then
    autocmd.create({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.document_highlight,
      desc = "Highlight references"
    })
  end
end

-- Allow other modules to subscribe to LSP events
event.on("LspAttach", function(client, bufnr)
  -- Keymaps are centralized and listen to this event
end)

return M
```

## Troubleshooting

### Common Issues

#### Module not loading
```lua
-- Check if module is available
local M = require("marvim.module")
if not M.is_available("module.name") then
  print("Module not available")
end

-- Check cache
local cache = require("marvim.cache")
cache.invalidate("module.name")
```

#### Event not firing
```lua
-- Debug event listeners
local event = require("marvim.event")
local listeners = event.get_listeners()
vim.print(listeners["YourEvent"])
```

#### Toggle not working
```lua
-- Check toggle registration
local toggle = require("marvim.toggle")
local state = toggle.state("feature")
print("Current state:", state)

-- List all toggles
vim.print(toggle.list())
```

#### Performance issues
```lua
-- Enable profiling
local profiler = require("marvim.profiler")
profiler.start()

-- Do operations...

-- Check report
profiler.stop()
vim.cmd("MarvimProfile")
```

### Migration Checklist

1. **Update requires to use module.load()**
   - Search for `pcall(require` patterns
   - Replace with `module.load()`

2. **Consolidate autocmds**
   - Search for `nvim_create_autocmd`
   - Move to autocmd groups

3. **Implement event communication**
   - Identify cross-module dependencies
   - Replace with event emit/on

4. **Add feature toggles**
   - Find toggle keybindings
   - Register with toggle system

5. **Define configuration schemas**
   - Extract configuration tables
   - Define with config.define()

6. **Update plugin specs**
   - Use plugin.spec() wrapper
   - Add proper error handling

## Breaking Changes

### Removed Functions

The following utility functions have been removed in favor of framework modules:

- `utils.safe_require()` → Use `marvim.module.load()`
- `utils.create_autocmd()` → Use `marvim.autocmd.create()`
- `utils.merge_config()` → Use `marvim.config.merge()`

### Changed Behavior

- **Module loading**: All requires are now cached by default
- **Autocmds**: Groups are automatically managed
- **Events**: Async by default, use `event.emit_sync()` for synchronous
- **Configuration**: Schema validation is enforced

### Deprecation Warnings

To check for deprecated API usage:

```lua
-- Enable deprecation warnings
local migrate = require("marvim.migrate")
migrate.enable_warnings(true)

-- Check current warnings
local warnings = migrate.get_warnings()
vim.print(warnings)
```

## Performance Tips

1. **Use lazy loading**
   ```lua
   -- Load only when needed
   M.on_load("heavy.module", function(mod)
     mod.setup()
   end)
   ```

2. **Cache expensive operations**
   ```lua
   local cache = require("marvim.cache")
   local result = cache.get("expensive") or cache.set("expensive",
     expensive_function(), 60000) -- Cache for 1 minute
   ```

3. **Profile startup**
   ```lua
   -- In init.lua
   local profiler = require("marvim.profiler")
   profiler.init({ auto_profile = true })
   ```

4. **Use event system for decoupling**
   ```lua
   -- Instead of direct dependencies
   event.on("Ready", function()
     -- Initialize features
   end)
   ```

## Getting Help

- Run `:MarvimHealth` to check framework status
- Run `:MarvimProfile` for performance analysis
- Check `~/.local/state/nvim/marvim.log` for detailed logs
- File issues at the repository with diagnostic output