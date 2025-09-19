# Investigation: MARVIM Architecture Audit

## Bottom Line

**Root Cause**: MARVIM has partial abstractions but lacks a cohesive framework layer, leading to code duplication and inconsistent patterns
**Fix Location**: Create `lua/marvim/` framework directory with core abstractions  
**Confidence**: High

## What's Happening

MARVIM has grown organically with 63 Lua files across multiple directories. While it has some utility modules (`utils/keymaps.lua`, `utils/lsp.lua`, `utils/theme.lua`), there's no consistent abstraction layer like LazyVim/AstroNvim provide. This results in repeated error handling patterns, inconsistent plugin configuration, and limited module communication.

## Why It Happens

**Primary Cause**: Organic growth without architectural framework
**Trigger**: Each plugin config independently handles common concerns
**Decision Point**: No standardized patterns for plugin authors to follow

## Evidence

- **Key File**: `lua/utils/keymaps.lua:43` - Safe keymap wrapper with conflict detection
- **Search Used**: `rg "pcall\(require"` - Found 20+ instances of repeated error handling
- **Pattern**: `lua/config/plugins/*` - Each plugin independently handles pcall, notifications, dependencies
- **Duplication**: `vim.api.nvim_create_autocmd` - 34 instances across 15 files without abstraction

## Current Architecture Assessment

### Strengths
1. **Centralized Keymaps**: Single source of truth in `config/keymaps.lua` with exported tables
2. **Utils Layer**: Has utilities for LSP, themes, keymaps with safe wrappers
3. **Modular Plugins**: Well-organized plugin categories (core, editor, lsp, etc.)

### Pain Points
1. **Repeated Error Handling**: Every plugin does `local ok, mod = pcall(require, ...)`  
2. **No Config API**: No standardized way to merge/override configs
3. **Inconsistent Notifications**: Mix of `vim.notify`, print, silent failures
4. **Module Communication**: Limited inter-module communication patterns
5. **No Toggle System**: No unified way to toggle features/settings
6. **Autocmd Management**: Scattered autocmd creation without central registry

## Cleanup Opportunities

### 1. Create Framework Layer (`lua/marvim/`)
```lua
marvim/
├── core/
│   ├── autocmd.lua   -- Autocmd registry with deduplication
│   ├── config.lua    -- Config merge/override system  
│   ├── lazy.lua      -- Lazy-loading helpers
│   └── notify.lua    -- Unified notification system
├── features/
│   ├── toggle.lua    -- Toggle system for features
│   ├── format.lua    -- Unified formatting API
│   └── picker.lua    -- Telescope/picker abstractions
└── init.lua          -- Public API surface
```

### 2. Standardize Plugin Configs
```lua
-- Before (scattered in each plugin)
local ok, mod = pcall(require, "module")
if not ok then return end

-- After (using framework)
return marvim.plugin({
  name = "plugin-name",
  dependencies = { "module" },
  config = function(opts, deps)
    -- deps.module guaranteed to exist
  end
})
```

### 3. Unified Config System
```lua
-- Like LazyVim's approach
marvim.config({
  lsp = {
    format_on_save = true,
    inlay_hints = { enabled = true }
  }
})

-- Plugins can access
local config = marvim.config.get("lsp.format_on_save")
```

## Would Distribution Architecture Help?

**YES** - A lightweight framework layer would provide:

1. **Code Reuse**: Common patterns abstracted once
2. **Consistency**: Standardized plugin configuration
3. **Safety**: Built-in error handling and validation
4. **Communication**: Event system for module interaction
5. **Extensibility**: Hooks and callbacks for customization
6. **Performance**: Centralized caching and lazy-loading

## Next Steps

1. Create `lua/marvim/core/` with essential abstractions (config, autocmd, notify)
2. Migrate high-value utilities first (safe_require, autocmd management)
3. Create plugin wrapper API for consistent configuration
4. Add toggle system for common features (format on save, inlay hints, etc.)
5. Document patterns for plugin authors

## Risks

- Over-abstraction could make config harder to understand
- Migration effort needs careful staging to avoid breakage
- Must maintain backward compatibility during transition
