# Snacks.nvim Migration Plan Overview

## Executive Summary

This document outlines a comprehensive plan to expand the usage of snacks.nvim in the current Neovim configuration, replacing several standalone plugins with snacks.nvim's integrated features. The migration will improve consistency, reduce dependencies, and leverage the unified API provided by snacks.nvim.

## Current State Analysis

### Already Using Snacks
- ✅ **snacks.input** (replaced dressing.nvim)
- ✅ **snacks.notifier** (replaced noice.nvim)
- ✅ **snacks.scope** (partial flash.nvim replacement)

### Migration Candidates
1. **persistence.nvim** → snacks.session
2. **lazygit.nvim** → snacks.lazygit
3. **flash.nvim** → snacks.jump (complete migration)
4. **todo-comments.nvim** → snacks picker with custom patterns
5. **dropbar.nvim** → snacks.statuscolumn (evaluate feasibility)

### Not Migrating
- **which-key.nvim** → Keep (snacks.toggle only covers basic toggles)

## Benefits of Migration

### 1. Reduced Complexity
- Fewer plugin dependencies to manage
- Single configuration paradigm
- Consistent keybinding patterns

### 2. Performance Improvements
- Single plugin initialization vs multiple
- Shared utilities and dependencies
- Optimized lazy loading

### 3. Enhanced Integration
- Unified notification system
- Consistent UI elements
- Shared color scheme integration

### 4. Maintenance Benefits
- Single upstream to track
- Fewer breaking changes to handle
- Simplified debugging

## Migration Strategy

### Phase 1: Low Risk Migrations (Week 1)
- Session management (persistence.nvim → snacks.session)
- Lazygit integration

### Phase 2: Medium Risk Migrations (Week 2)
- Flash.nvim → snacks.jump
- Evaluate dropbar → statuscolumn feasibility

### Phase 3: Optional Enhancements (Week 3)
- Todo-comments custom picker
- Additional snacks features exploration

## Risk Assessment

### Low Risk
- **Session management**: Simple API mapping
- **Lazygit**: Drop-in replacement

### Medium Risk
- **Flash.nvim migration**: Muscle memory adjustment needed
- **Statuscolumn**: May not have feature parity

### High Risk
- **Todo-comments**: Requires custom implementation

## Success Criteria

1. All migrated features maintain or exceed current functionality
2. No degradation in performance
3. Keybindings remain consistent or improved
4. Configuration is more maintainable

## Directory Structure

```
nvim-findings/snacks/
├── overview.md (this file)
├── session-migration.md
├── lazygit-migration.md
├── jump-migration.md
├── todo-picker.md
├── implementation-timeline.md
└── config-examples/
    ├── session.lua
    ├── lazygit.lua
    ├── jump.lua
    └── picker.lua
```

## Next Steps

1. Review each detailed migration document
2. Test migrations in isolated branch
3. Implement phased rollout
4. Document any custom configurations needed
5. Update keymaps and documentation