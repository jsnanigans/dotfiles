# Plan: MARVIM Framework Architecture Refactor

## Decision

**Approach**: Create lightweight framework layer with Config API, Module system, and Feature toggles
**Why**: Eliminate code duplication (20+ pcall patterns, 34 autocmd instances) while maintaining simplicity
**Risk Level**: Medium (phased migration mitigates breakage risk)

## Implementation Steps

### Phase 1: Core Framework (Week 1)

1. **Create framework core** - Add `lua/marvim/init.lua` with namespace setup
2. **Build Config API** - Add `lua/marvim/config.lua` for unified configuration
3. **Add Module system** - Create `lua/marvim/module.lua` for safe requires
4. **Implement Utils** - Add `lua/marvim/utils.lua` consolidating common patterns
5. **Setup Autocmd manager** - Create `lua/marvim/autocmd.lua` for centralized management

### Phase 2: Feature Systems (Week 2)

6. **Add Toggle system** - Create `lua/marvim/toggle.lua` for feature flags
7. **Build Event system** - Add `lua/marvim/event.lua` for module communication
8. **Create Plugin API** - Add `lua/marvim/plugin.lua` wrapping lazy.nvim patterns
9. **Add Cache layer** - Create `lua/marvim/cache.lua` for performance optimization

### Phase 3: Migration Layer (Week 3)

10. **Create migration utils** - Add `lua/marvim/migrate.lua` with backward compat shims
11. **Migrate core modules** - Update `lua/config/lazy.lua` to use framework
12. **Convert keymaps** - Refactor `lua/config/keymaps/*.lua` to use new API
13. **Update LSP config** - Migrate `lua/config/plugins/lsp/*.lua` to framework

### Phase 4: Plugin Migration (Week 4)

14. **Migrate simple plugins** - Convert consolidated plugin files first
15. **Update complex plugins** - Migrate individual plugin configs with care
16. **Convert utils** - Update `lua/utils/*.lua` to use framework
17. **Add deprecation warnings** - Mark old patterns for removal

### Phase 5: Polish & Documentation (Week 5)

18. **Add diagnostics** - Create `:MarvimHealth` command for framework status
19. **Write migration guide** - Document patterns and API changes
20. **Performance profiling** - Ensure no startup regression

## Files to Change

### New Framework Files
- `lua/marvim/init.lua` - Framework namespace and initialization
- `lua/marvim/config.lua` - Configuration API with defaults and merging
- `lua/marvim/module.lua` - Safe require with caching and error handling
- `lua/marvim/autocmd.lua` - Autocmd groups and management
- `lua/marvim/toggle.lua` - Feature toggle system
- `lua/marvim/event.lua` - Event emitter for module communication
- `lua/marvim/plugin.lua` - Plugin configuration helpers
- `lua/marvim/cache.lua` - Module and computation caching
- `lua/marvim/utils.lua` - Common utilities (tables, strings, paths)

### Modified Files
- `init.lua` - Add framework initialization before lazy.nvim
- `lua/config/lazy.lua` - Use framework for plugin loading
- `lua/config/keymaps.lua` - Integrate with toggle system
- `lua/config/plugins/lsp/config.lua` - Use module system for requires
- `lua/utils/*.lua` - Gradually deprecate in favor of framework utils

## Acceptance Criteria

- [ ] No breaking changes during migration phases
- [ ] Startup time remains under 100ms
- [ ] All 20+ pcall patterns replaced with module.load()
- [ ] 34 autocmd instances managed through framework
- [ ] Feature toggles working for major components
- [ ] `:MarvimHealth` shows framework status
- [ ] Module communication via events demonstrated
- [ ] Cache hit rate > 80% for repeated requires

## Risks & Mitigations

**Main Risk**: Breaking existing functionality during migration
**Mitigation**: Backward compatibility layer, extensive testing between phases

**Secondary Risk**: Over-abstraction leading to complexity
**Mitigation**: Keep abstractions minimal, focus on actual pain points

**Performance Risk**: Framework overhead impacting startup
**Mitigation**: Aggressive caching, lazy loading, profiling at each phase

## Out of Scope

- Complete rewrite of plugin configurations
- Migration to different plugin manager
- Changing fundamental keymap structure
- Adding new plugins or features
- Creating extensive documentation beyond migration guide

## Technical Details

### Config API Example
```lua
local config = require("marvim.config")
config.setup({
  features = {
    copilot = true,
    snippets = false,
  },
  lsp = {
    format_on_save = true,
    virtual_text = "mini",
  }
})
```

### Module System Example
```lua
local M = require("marvim.module")
local treesitter = M.load("nvim-treesitter.configs")  -- Safe with caching
M.on_load("telescope", function(telescope)  -- Deferred loading
  telescope.load_extension("fzf")
end)
```

### Event System Example
```lua
local events = require("marvim.event")
events.on("LspAttach", function(client, buffer)
  -- Setup keymaps, etc
end)
events.emit("LspAttach", client, buffer)
```

### Toggle System Example
```lua
local toggle = require("marvim.toggle")
toggle.register("diagnostics", {
  on = function() vim.diagnostic.enable() end,
  off = function() vim.diagnostic.disable() end,
  status = function() return vim.diagnostic.is_enabled() end
})
```

## Success Metrics

- Code reduction: 30% fewer lines through abstraction
- Error resilience: Zero startup failures from missing modules
- Performance: Startup time unchanged or improved
- Maintainability: New features require 50% less boilerplate
- Consistency: All plugins follow same configuration pattern