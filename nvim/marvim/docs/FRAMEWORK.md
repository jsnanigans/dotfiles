# MARVIM Framework Documentation

## Architecture Overview

The MARVIM framework is a lightweight, modular architecture layer for Neovim configurations that provides consistent patterns, error resilience, and performance optimization.

### Design Principles

1. **Minimal Abstraction**: Only abstract actual pain points
2. **Zero Breaking Changes**: Backward compatibility during migration
3. **Performance First**: Aggressive caching, lazy loading
4. **Error Resilience**: Graceful degradation, comprehensive error handling
5. **Discoverable API**: Clear naming, consistent patterns

### Architecture Diagram

```
┌─────────────────────────────────────────────────────┐
│                    User Configuration                │
├─────────────────────────────────────────────────────┤
│                    Plugin Layer                      │
│          (Telescope, LSP, Treesitter, etc.)         │
├─────────────────────────────────────────────────────┤
│                  MARVIM Framework                    │
│  ┌─────────┐ ┌────────┐ ┌────────┐ ┌────────┐     │
│  │ Module  │ │ Config │ │ Event  │ │ Toggle │     │
│  │ System  │ │   API  │ │ System │ │ System │     │
│  └─────────┘ └────────┘ └────────┘ └────────┘     │
│  ┌─────────┐ ┌────────┐ ┌────────┐ ┌────────┐     │
│  │ Autocmd │ │ Cache  │ │ Plugin │ │ Utils  │     │
│  │ Manager │ │ Layer  │ │  API   │ │        │     │
│  └─────────┘ └────────┘ └────────┘ └────────┘     │
├─────────────────────────────────────────────────────┤
│                   Neovim Core API                    │
└─────────────────────────────────────────────────────┘
```

## Module System (`marvim.module`)

The module system provides safe, cached module loading with automatic error handling.

### Purpose
- Eliminate repetitive `pcall(require, ...)` patterns
- Provide consistent error handling
- Enable module caching for performance
- Support deferred loading

### API

#### `module.load(name)`
Safely loads a module with caching.

```lua
local module = require("marvim.module")
local telescope = module.load("telescope")
if telescope then
  telescope.setup({})
end
```

#### `module.on_load(name, callback)`
Registers a callback for when a module becomes available.

```lua
module.on_load("telescope", function(telescope)
  telescope.load_extension("fzf")
end)
```

#### `module.is_available(name)`
Checks if a module can be loaded without actually loading it.

```lua
if module.is_available("copilot") then
  -- Configure copilot-specific features
end
```

### Implementation Details
- Modules are cached after first successful load
- Failed loads are tracked to avoid repeated attempts
- Callbacks are stored and executed when module loads
- Cache can be invalidated for reload

## Configuration API (`marvim.config`)

Centralized configuration management with schema validation and merging.

### Purpose
- Define configuration schemas with defaults
- Validate configuration values
- Merge user and default configurations
- Provide type safety

### API

#### `config.define(namespace, schema)`
Defines a configuration namespace with schema.

```lua
local config = require("marvim.config")

config.define("lsp", {
  format_on_save = {
    default = true,
    type = "boolean",
    description = "Format buffer on save"
  },
  virtual_text = {
    default = "mini",
    type = "string",
    enum = { "off", "mini", "full" }
  }
})
```

#### `config.get(namespace)`
Retrieves merged configuration for namespace.

```lua
local lsp_config = config.get("lsp")
if lsp_config.format_on_save then
  -- Setup format on save
end
```

#### `config.set(namespace, values)`
Updates configuration values.

```lua
config.set("lsp", {
  format_on_save = false
})
```

### Schema Options
- `default`: Default value if not specified
- `type`: Expected type (string, boolean, number, table, function)
- `required`: Whether the option must be provided
- `enum`: List of valid values
- `description`: Documentation for the option
- `validate`: Custom validation function

## Event System (`marvim.event`)

Decoupled communication between modules via events.

### Purpose
- Enable loose coupling between modules
- Support plugin lifecycle hooks
- Provide debugging and introspection
- Allow extension without modification

### API

#### `event.emit(name, ...)`
Emits an event with arguments.

```lua
local event = require("marvim.event")
event.emit("LspAttach", client, buffer)
```

#### `event.on(name, handler)`
Subscribes to an event.

```lua
local unsubscribe = event.on("LspAttach", function(client, buffer)
  -- Configure LSP buffer
end)
```

#### `event.once(name, handler)`
Subscribes to an event for one emission only.

```lua
event.once("FirstLoad", function()
  -- One-time initialization
end)
```

### Standard Events
- `Ready`: Framework initialization complete
- `LspAttach`: LSP client attached to buffer
- `LspDetach`: LSP client detached from buffer
- `ColorSchemeChange`: Colorscheme changed
- `PluginLoaded`: Plugin finished loading
- `ConfigReload`: Configuration reloaded

## Toggle System (`marvim.toggle`)

Unified interface for feature toggles.

### Purpose
- Consistent toggle behavior across features
- State persistence and restoration
- Integration with keymaps
- Status reporting

### API

#### `toggle.register(name, spec)`
Registers a new toggle.

```lua
local toggle = require("marvim.toggle")

toggle.register("diagnostics", {
  on = function() vim.diagnostic.enable() end,
  off = function() vim.diagnostic.disable() end,
  status = function() return vim.diagnostic.is_enabled() end,
  desc = "Toggle diagnostics"
})
```

#### `toggle.toggle(name)`
Toggles a feature on/off.

```lua
toggle.toggle("diagnostics")
```

#### `toggle.set(name, state)`
Sets toggle to specific state.

```lua
toggle.set("diagnostics", false) -- Turn off
```

### Integration
Toggles automatically integrate with:
- Which-key for discoverability
- Status line for current state
- Health check for validation
- Persistence across sessions

## Autocmd Manager (`marvim.autocmd`)

Centralized autocmd management with groups.

### Purpose
- Eliminate scattered autocmd definitions
- Provide group management
- Enable safe cleanup
- Add debugging capabilities

### API

#### `autocmd.group(name, opts)`
Creates or retrieves an autocmd group.

```lua
local autocmd = require("marvim.autocmd")
local group = autocmd.group("LspFormat", { clear = true })
```

#### `autocmd.create(event, opts)`
Creates an autocmd with error handling.

```lua
autocmd.create("BufWritePre", {
  group = group,
  pattern = "*.lua",
  callback = function()
    vim.lsp.buf.format()
  end,
  desc = "Format Lua files on save"
})
```

### Group Management
- Groups are automatically tracked
- Clear option removes existing autocmds
- Groups can be listed for debugging
- Cleanup on module unload

## Cache Layer (`marvim.cache`)

High-performance caching for expensive operations.

### Purpose
- Cache module loads
- Store computation results
- Implement TTL (time-to-live)
- Provide cache statistics

### API

#### `cache.set(key, value, ttl)`
Stores a value with optional TTL.

```lua
local cache = require("marvim.cache")
cache.set("expensive_result", compute(), 60000) -- 1 minute TTL
```

#### `cache.get(key)`
Retrieves a cached value.

```lua
local result = cache.get("expensive_result")
if not result then
  result = compute()
  cache.set("expensive_result", result, 60000)
end
```

### Cache Strategy
- LRU eviction when size limit reached
- TTL-based expiration
- Manual invalidation
- Statistics for monitoring

## Plugin API (`marvim.plugin`)

Helpers for plugin configuration.

### Purpose
- Standardize plugin specifications
- Provide common configuration patterns
- Enable conditional loading
- Add performance profiling

### API

#### `plugin.spec(name, opts)`
Creates a plugin specification.

```lua
local plugin = require("marvim.plugin")

return plugin.spec("nvim-treesitter/nvim-treesitter", {
  build = ":TSUpdate",
  config = plugin.config("nvim-treesitter.configs", {
    highlight = { enable = true },
    indent = { enable = true }
  })
})
```

#### `plugin.config(module_name, opts)`
Creates a config function with error handling.

```lua
config = plugin.config("telescope", {
  defaults = {
    layout_strategy = "flex"
  }
})
```

### Features
- Automatic error handling
- Lazy loading support
- Dependency management
- Performance tracking

## Utilities (`marvim.utils`)

Common utility functions used across the framework.

### Categories

#### Table Utilities
- `tbl_deep_merge`: Deep merge tables
- `tbl_filter`: Filter table elements
- `tbl_map`: Map function over table
- `tbl_flatten`: Flatten nested tables

#### String Utilities
- `str_split`: Split string by delimiter
- `str_trim`: Remove whitespace
- `str_starts_with`: Check string prefix
- `str_ends_with`: Check string suffix

#### Path Utilities
- `path_join`: Join path segments
- `path_exists`: Check if path exists
- `path_is_file`: Check if path is file
- `path_is_dir`: Check if path is directory

#### Function Utilities
- `debounce`: Debounce function calls
- `throttle`: Throttle function calls
- `once`: Ensure function runs once
- `memoize`: Cache function results

## Best Practices

### Module Organization
```lua
-- Start with framework requires
local M = require("marvim.module")
local config = require("marvim.config")
local event = require("marvim.event")

-- Define configuration schema
config.define("my_feature", {
  option = { default = "value" }
})

-- Export module
local module = {}

-- Use framework features
function module.setup()
  local opts = config.get("my_feature")
  event.emit("MyFeatureSetup", opts)
end

return module
```

### Error Handling
```lua
-- Let framework handle errors
local telescope = M.load("telescope")
if not telescope then
  return -- Framework already logged error
end

-- Or use callbacks for optional features
M.on_load("optional_plugin", function(plugin)
  plugin.setup()
end)
```

### Performance Optimization
```lua
-- Cache expensive operations
local cache = require("marvim.cache")

local function expensive_operation()
  local cached = cache.get("result")
  if cached then return cached end

  local result = -- expensive computation
  cache.set("result", result, 300000) -- 5 minute cache
  return result
end
```

### Event-Driven Architecture
```lua
-- Emit events for extensibility
event.emit("BeforeAction", data)
perform_action(data)
event.emit("AfterAction", data)

-- Subscribe from other modules
event.on("BeforeAction", function(data)
  -- Prepare for action
end)
```

## Extension Guide

### Creating a Framework Module

```lua
-- lua/marvim/my_module.lua
local M = {}

-- Dependencies
local config = require("marvim.config")
local event = require("marvim.event")

-- Private state
local state = {
  initialized = false
}

-- Public API
function M.init(opts)
  if state.initialized then return end

  opts = config.merge("my_module", opts)

  -- Setup module
  state.initialized = true
  event.emit("MyModuleInit", opts)
end

-- Export
return M
```

### Adding to Framework

1. Create module in `lua/marvim/`
2. Add to framework init if needed
3. Document API in this file
4. Add tests if applicable
5. Update health check

### Integration Points

The framework provides multiple integration points:

1. **Module Hooks**: `on_load` callbacks
2. **Event System**: Subscribe to lifecycle events
3. **Configuration**: Define schemas for options
4. **Toggles**: Register feature toggles
5. **Cache**: Store computed values
6. **Autocmds**: Managed event handlers

## Debugging

### Health Check
```vim
:MarvimHealth
```
Shows complete framework status including:
- Module load status
- Cache performance
- Event listeners
- Toggle states
- Migration warnings

### Performance Profiling
```vim
:MarvimProfile
```
Displays performance metrics:
- Startup time breakdown
- Module load times
- Cache hit rates
- Memory usage
- Slow operations

### Event Debugging
```lua
-- List all event listeners
local event = require("marvim.event")
vim.print(event.get_listeners())

-- Trace event emissions
event.on("*", function(name, ...)
  print("Event:", name, ...)
end)
```

### Module Debugging
```lua
-- Check module availability
local M = require("marvim.module")
print(M.is_available("module.name"))

-- List loaded modules
vim.print(package.loaded)
```

## FAQ

### Q: How much overhead does the framework add?
A: Negligible. With caching and lazy loading, the framework typically reduces startup time by eliminating redundant operations.

### Q: Can I use the framework partially?
A: Yes. Each module is independent and can be adopted incrementally.

### Q: How do I migrate existing configuration?
A: See [MIGRATION.md](./MIGRATION.md) for detailed migration guide.

### Q: Is the framework Neovim version specific?
A: The framework requires Neovim 0.9+ for full functionality, with graceful degradation for older versions.

### Q: How do I contribute?
A: Follow the extension guide above. Ensure changes maintain backward compatibility and include tests.

## Resources

- [Migration Guide](./MIGRATION.md) - Step-by-step migration instructions
- [Plan Document](../plans/framework-refactor.md) - Original design decisions
- [Architecture Audit](../reports/architecture-audit.md) - Current state analysis