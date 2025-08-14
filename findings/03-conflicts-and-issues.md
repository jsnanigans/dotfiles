# Conflicts and Issues Analysis

## Critical Conflicts

### 1. Alt-hjkl Keybinding Collision
**Severity**: 🔴 High  
**Tools Affected**: Neovim, Tmux, AeroSpace

#### Current Bindings
```yaml
Neovim:
  Alt-h: Decrease window width
  Alt-j: Decrease window height
  Alt-k: Increase window height
  Alt-l: Increase window width

Tmux:
  Alt-h: Select pane left (no prefix needed)
  Alt-j: Select pane down (no prefix needed)
  Alt-k: Select pane up (no prefix needed)
  Alt-l: Select pane right (no prefix needed)

AeroSpace:
  Alt-h: Focus window left
  Alt-j: Focus window down
  Alt-k: Focus window up
  Alt-l: Focus window right
```

#### Impact
- Unpredictable behavior depending on focus context
- Muscle memory confusion
- Reduced efficiency in window/pane management

#### Root Cause
- All three tools claim the same global shortcuts
- No clear hierarchy established
- AeroSpace captures at OS level, preventing terminal apps from receiving

### 2. Theme Inconsistency
**Severity**: 🟡 Medium  
**Tools Affected**: Neovim vs all others

#### Current State
```lua
-- Neovim (marvim)
colorscheme = "nord"

-- Tmux, Fish, Ghostty
theme = "rose-pine"
```

#### Impact
- Visual discontinuity when switching between nvim and shell
- Cognitive load from color context switching
- Reduced aesthetic cohesion

### 3. Session Management Fragmentation
**Severity**: 🟡 Medium  
**Tools Affected**: Tmux, Fish, Neovim

#### Competing Systems
1. **Fish `tm` function**: Custom session manager
2. **Tmux native sessions**: Built-in functionality
3. **Neovim persistence**: Session.nvim plugin
4. **No unified project discovery**

#### Impact
- Multiple ways to achieve same goal
- Inconsistent project switching experience
- Lost context when moving between tools

## Minor Issues

### 4. Clipboard Integration Gaps
**Severity**: 🟢 Low  
**Tools Affected**: Remote sessions

- OSC 52 not consistently configured
- Different clipboard commands across tools
- SSH clipboard forwarding issues

### 5. Git Integration Disparity
**Severity**: 🟢 Low  
**Tools Affected**: Tmux (lacking), Neovim (rich), Fish (basic)

- No git integration in tmux status
- Different git UIs (LazyGit vs CLI)
- Inconsistent commit workflows

### 6. LSP Workspace Isolation
**Severity**: 🟢 Low  
**Tools Affected**: Neovim only

- LSP benefits don't extend to terminal
- No workspace-wide refactoring from shell
- Language server state not shared

## Configuration Issues

### 7. Color Definition Duplication
**Files with Rose Pine definitions**:
```
/fish/conf.d/rose_pine_colors.fish
/tmux/theme.conf
/ghostty/config (references theme)
/nvim/marvim/lua/utils/theme.lua (different theme!)
```

**Problems**:
- No single source of truth
- Risk of drift over time
- Maintenance overhead

### 8. Path Configuration Redundancy
**Multiple PATH definitions**:
```fish
# fish/conf.d/00_path.fish
fish_add_path /opt/homebrew/bin
fish_add_path ~/.local/bin

# Also in fish/config.fish
set -gx PATH ...
```

### 9. Function Naming Inconsistency
**Different naming conventions**:
```fish
# Underscore style
__fish_npm_scripts
__z_add

# Hyphen style
tmux-launcher
tmux-search

# No separator
gwe
tm
```

## Performance Issues

### 10. Startup Time Accumulation
**Combined startup overhead**:
- Ghostty: ~200ms
- Tmux: ~50ms
- Fish: ~30ms
- Neovim: ~100ms
**Total**: ~380ms for full stack

### 11. Lazy Loading Gaps
**Not lazy loaded**:
- Tmux plugins load immediately
- Some fish conf.d files
- Ghostty has no lazy loading

## Missing Features

### 12. No Unified Help System
- Neovim: which-key
- Tmux: tmux-which-key (separate)
- Fish: No help system
- No cross-tool documentation

### 13. Project-Specific Configuration
**Not implemented**:
- Per-project nvim settings
- Per-project shell environments
- Per-project tmux layouts

### 14. Testing Integration
- Tests run only in nvim
- No tmux pane for test output
- No shell test runners

## Security Concerns

### 15. Credential Management
**Potential issues**:
- Git credentials in plain text?
- SSH keys without agent?
- No secret management system

## Maintenance Debt

### 16. Documentation Gaps
**Missing documentation**:
- Custom function usage
- Keybinding cheatsheet
- Integration guide

### 17. Version Pinning
**Unpinned dependencies**:
- Fish plugins via Fisher
- Tmux plugins via TPM
- Only nvim has lock file

## Conflict Resolution Priority Matrix

| Issue | Impact | Effort | Priority | Resolution Strategy |
|-------|--------|--------|----------|-------------------|
| Alt-hjkl collision | High | Low | 🔴 P0 | Change AeroSpace to Cmd+Alt |
| Theme inconsistency | Medium | Low | 🟡 P1 | Switch nvim to Rose Pine |
| Session fragmentation | Medium | Medium | 🟡 P1 | Unified project manager |
| Color duplication | Low | Medium | 🟢 P2 | Central theme file |
| Missing help system | Low | High | 🟢 P3 | Build unified docs |

## Recommended Fix Order

### Phase 1: Critical Fixes (Week 1)
1. ✅ Resolve Alt-hjkl conflict
2. ✅ Standardize theme to Rose Pine
3. ✅ Document current keybindings

### Phase 2: Integration (Week 2-3)
1. ✅ Unified project/session management
2. ✅ Centralize color definitions
3. ✅ Consistent git integration

### Phase 3: Enhancement (Week 4+)
1. ✅ Add missing help systems
2. ✅ Implement project configs
3. ✅ Optimize performance

## Validation Checklist
- [ ] All Alt-hjkl commands work as expected
- [ ] Theme is consistent across all tools
- [ ] Project switching is seamless
- [ ] No duplicate functionality
- [ ] Documentation is complete
- [ ] Performance meets targets (<300ms total)