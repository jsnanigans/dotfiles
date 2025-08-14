# Neovim Configuration Migration Plan
## From 63 Plugins to ~40: A Practical Simplification Strategy

### Migration Overview

**Current State**: 63 plugins with complex interdependencies  
**Target State**: ~40 plugins using mini.nvim + snacks.nvim collections  
**Timeline**: 4-6 weeks  
**Risk Level**: Low to Medium  
**Estimated Effort**: 20-30 hours total  

### Migration Philosophy

**Hybrid Approach**: Combine the best of both mini.nvim and snacks.nvim
- **Mini.nvim**: Text editing primitives and core functionality
- **Snacks.nvim**: Modern UI/UX and developer tools  
- **Specialized plugins**: Keep only essential LSP, DAP, and language-specific tools

---

## Phase 1: Preparation & Quick Wins (Week 1)
**Goal**: Remove obvious redundancies, prepare configuration  
**Time Required**: 2-3 hours  
**Risk**: Minimal  

### Actions:
1. **Backup current configuration**
   ```bash
   cp -r ./nvim/marvim ./nvim/marvim.backup
   git commit -am "Backup before migration"
   ```

2. **Remove redundant plugins immediately**
   - [ ] Remove `git-blame.nvim` (use gitsigns instead)
   - [ ] Remove `vim-illuminate` (use LSP document highlight)
   - [ ] Remove `FixCursorHold.nvim` (fixed in newer Neovim)
   - [ ] Remove `nvim-web-devicons` (keep mini.icons)

3. **Document current keybindings**
   ```vim
   :redir > ~/current-keybindings.txt
   :silent verbose map
   :redir END
   ```

4. **Create migration branch**
   ```bash
   git checkout -b nvim-simplification
   ```

### Expected Results:
- Plugin count: 63 → 59
- No functionality lost
- Cleaner dependency tree

---

## Phase 2: Snacks.nvim Expansion (Week 2)
**Goal**: Maximize snacks.nvim usage for UI/UX  
**Time Required**: 4-5 hours  
**Risk**: Low  

### Enable Core Snacks Modules:
```lua
-- In lazy.nvim config for snacks.nvim
opts = {
  -- Existing
  picker = { enabled = true },
  
  -- New additions
  bigfile = { enabled = true },        -- Performance
  bufdelete = { enabled = true },      -- Buffer management
  gitbrowse = { enabled = true },      -- Git integration
  indent = { enabled = true },         -- Indentation
  input = { enabled = true },          -- Better vim.ui.input
  notifier = { enabled = true },       -- Notifications
  quickfile = { enabled = true },      -- Fast file loading
  scope = { enabled = true },          -- Scope detection
  scroll = { enabled = true },         -- Smooth scrolling
  statuscolumn = { enabled = true },   -- Pretty statuscolumn
  terminal = { enabled = true },       -- Terminal management
  words = { enabled = true },          -- Word highlighting
  dashboard = { enabled = true },      -- Start screen
  lazygit = { enabled = true },        -- Git UI
}
```

### Remove Replaced Plugins:
- [ ] Remove `lazygit.nvim` → use snacks.lazygit
- [ ] Remove `vim-illuminate` → use snacks.words
- [ ] Remove `dressing.nvim` → use snacks.input
- [ ] Remove `mini.indentscope` → use snacks.indent
- [ ] Remove `mini.bufremove` → use snacks.bufdelete
- [ ] Consider removing `noice.nvim` + `nui.nvim` → use snacks.notifier

### Expected Results:
- Plugin count: 59 → 52
- Unified UI/UX system
- Better integration

---

## Phase 3: Mini.nvim Consolidation (Week 3)
**Goal**: Expand mini.nvim for text editing features  
**Time Required**: 5-6 hours  
**Risk**: Medium  

### Add Mini Modules:
```lua
-- Add to your mini.nvim configurations
{ 'echasnovski/mini.pairs', config = function() require('mini.pairs').setup() end },
{ 'echasnovski/mini.comment', config = function() require('mini.comment').setup() end },
{ 'echasnovski/mini.files', config = function() require('mini.files').setup() end },
{ 'echasnovski/mini.git', config = function() require('mini.git').setup() end },
{ 'echasnovski/mini.diff', config = function() require('mini.diff').setup() end },
{ 'echasnovski/mini.sessions', config = function() require('mini.sessions').setup() end },
{ 'echasnovski/mini.clue', config = function() require('mini.clue').setup() end },
{ 'echasnovski/mini.bracketed', config = function() require('mini.bracketed').setup() end },
{ 'echasnovski/mini.jump2d', config = function() require('mini.jump2d').setup() end },
```

### Remove Replaced Plugins:
- [ ] Remove `nvim-autopairs` → use mini.pairs
- [ ] Remove `ts-comments.nvim` → use mini.comment
- [ ] Remove `oil.nvim` → use mini.files (or keep if preferred)
- [ ] Remove `git-conflict.nvim` → use mini.git
- [ ] Remove `persistence.nvim` → use mini.sessions
- [ ] Remove `which-key.nvim` → use mini.clue
- [ ] Remove `flash.nvim` → use mini.jump2d

### Expected Results:
- Plugin count: 52 → 45
- Consistent mini.nvim ecosystem
- Simplified configuration

---

## Phase 4: Testing Infrastructure Optimization (Week 4)
**Goal**: Streamline testing and debugging setup  
**Time Required**: 4-5 hours  
**Risk**: Medium  

### Lazy-load Test Adapters:
```lua
-- Only load adapters for languages you actually use
{
  "nvim-neotest/neotest",
  dependencies = {
    -- Only include what you need
    "nvim-neotest/neotest-jest",     -- Keep if using JavaScript
    "nvim-neotest/neotest-python",   -- Keep if using Python
    -- Remove unused adapters:
    -- "nvim-neotest/neotest-vitest",
    -- "nvim-neotest/neotest-go",
    -- "nvim-neotest/neotest-dart",
    -- "nvim-neotest/neotest-plenary",
  },
  -- Load only when running tests
  cmd = { "Neotest" },
  keys = {
    { "<leader>t", "", desc = "+test" },
  },
}
```

### Conditional DAP Loading:
```lua
-- Load debugging only when needed
{
  "mfussenegger/nvim-dap",
  lazy = true,
  cmd = { "DapContinue", "DapToggleBreakpoint" },
  dependencies = {
    -- Load dependencies only with DAP
  },
}
```

### Expected Results:
- Plugin count: 45 → 42
- Faster startup
- Memory savings

---

## Phase 5: Final Optimization (Week 5-6)
**Goal**: Fine-tune and optimize  
**Time Required**: 3-4 hours  
**Risk**: Low  

### Performance Optimizations:
1. **Audit startup time**
   ```vim
   :StartupTime
   ```

2. **Review lazy-loading**
   - Ensure heavy plugins load on-demand
   - Check for unnecessary early loads

3. **Consolidate keymaps**
   - Migrate to new plugin keybindings
   - Remove duplicate mappings
   - Update muscle memory documentation

4. **Clean up configurations**
   - Remove unused config files
   - Consolidate similar settings
   - Update documentation

### Final Cleanup:
- [ ] Remove `overseer.nvim` if neotest covers needs
- [ ] Consider removing `dropbar.nvim` if not essential
- [ ] Evaluate `diffview.nvim` vs mini.diff
- [ ] Clean up unused configuration files

### Expected Final State:
- **Plugin count**: ~40
- **Categories**:
  - Core/Dependencies: 3
  - LSP/Completion: 6-7
  - Mini.nvim modules: 10-12
  - Snacks.nvim modules: 15-18
  - Essential tools: 5-7

---

## Migration Checklist

### Pre-Migration
- [ ] Backup configuration
- [ ] Document current keybindings
- [ ] Create git branch
- [ ] Test in isolated environment

### Week 1
- [ ] Remove redundant plugins (4 plugins)
- [ ] Setup migration tracking
- [ ] Test basic functionality

### Week 2  
- [ ] Expand snacks.nvim usage
- [ ] Remove replaced UI plugins
- [ ] Update UI-related keybindings

### Week 3
- [ ] Add mini.nvim modules
- [ ] Remove replaced editing plugins
- [ ] Update editing keybindings

### Week 4
- [ ] Optimize testing setup
- [ ] Lazy-load debugging
- [ ] Clean configurations

### Week 5-6
- [ ] Performance testing
- [ ] Final optimizations
- [ ] Documentation update
- [ ] Training period

### Post-Migration
- [ ] Monitor for issues (1 week)
- [ ] Fine-tune configurations
- [ ] Document new workflows
- [ ] Consider further optimizations

---

## Rollback Plan

If issues arise at any phase:

1. **Immediate Rollback**
   ```bash
   git checkout main
   cp -r ./nvim/marvim.backup ./nvim/marvim
   ```

2. **Partial Rollback**
   - Keep working changes
   - Revert specific problematic plugins
   - Maintain hybrid setup temporarily

3. **Gradual Adoption**
   - Slow migration over months
   - Test each change thoroughly
   - Keep parallel configurations

---

## Success Metrics

### Quantitative
- [ ] Plugin count reduced by 35%+
- [ ] Startup time improved by 25%+
- [ ] Memory usage reduced by 20%+
- [ ] Config files reduced by 30%+

### Qualitative
- [ ] Easier configuration maintenance
- [ ] More consistent keybindings
- [ ] Better integrated features
- [ ] Improved developer experience

---

## Long-term Vision (3-6 months)

### Potential Further Optimizations:
1. **Native Neovim features**: Use more built-in functionality
2. **Single collection**: Consider full mini.nvim OR snacks.nvim
3. **Custom modules**: Write specific functionality as needed
4. **Ultra-minimal**: Reduce to 25-30 essential plugins

### Continuous Improvement:
- Regular plugin audits (quarterly)
- Performance monitoring
- Feature reassessment
- Community best practices

---

## Support Resources

### Documentation
- [Mini.nvim Documentation](https://github.com/echasnovski/mini.nvim)
- [Snacks.nvim Documentation](https://github.com/folke/snacks.nvim)
- Current config backup in `./nvim/marvim.backup`

### Community
- Neovim Discord/Matrix
- Reddit r/neovim
- GitHub issues for specific plugins

### Testing
- Use separate Neovim config for testing
- `NVIM_APPNAME=nvim-test nvim`
- Virtual machine or container testing

---

## Final Notes

This migration plan prioritizes:
1. **Stability**: Gradual changes with rollback options
2. **Functionality**: No feature loss, only consolidation
3. **Performance**: Measurable improvements
4. **Maintainability**: Simpler, more cohesive configuration

Remember: The goal is not just fewer plugins, but a more maintainable and efficient development environment. Take time with each phase and adjust based on your specific needs.