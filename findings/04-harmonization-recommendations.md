# Harmonization Recommendations

## Overview
This document provides actionable recommendations for harmonizing your terminal toolchain, organized by priority and implementation complexity.

## Priority 1: Critical Harmonization (Immediate)

### 1.1 Resolve Alt-hjkl Keybinding Conflict

#### Option A: Hyper Key Pattern (Recommended)
**Implementation for AeroSpace**:
```toml
# .aerospace.toml
# Use Cmd+Alt for window management (Hyper key pattern)
cmd-alt-h = 'focus left'
cmd-alt-j = 'focus down'  
cmd-alt-k = 'focus up'
cmd-alt-l = 'focus right'

# Move windows with Cmd+Alt+Shift
cmd-alt-shift-h = 'move left'
cmd-alt-shift-j = 'move down'
cmd-alt-shift-k = 'move up'
cmd-alt-shift-l = 'move right'
```

**Benefits**:
- Preserves Alt-hjkl for terminal apps
- Creates logical hierarchy: OS (Cmd+Alt) > Terminal (Alt) > App (Ctrl)
- Follows macOS conventions

#### Option B: Leader Key Pattern
**Alternative implementation**:
```toml
# Use Alt+Space as leader for window operations
alt-space = 'mode window'

[mode.window.binding]
h = 'focus left'
j = 'focus down'
k = 'focus up'
l = 'focus right'
```

### 1.2 Unify Theme to Rose Pine

**Step 1: Switch Neovim to Rose Pine**
```lua
-- nvim/marvim/lua/config/lazy.lua
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "main", -- main, moon, or dawn
        dark_variant = "main",
        disable_background = false,
        disable_float_background = false,
      })
      vim.cmd("colorscheme rose-pine")
    end,
  },
}
```

**Step 2: Create consistent highlight groups**
```lua
-- nvim/marvim/lua/utils/highlights.lua
local colors = {
  base = "#191724",
  surface = "#1f1d2e",
  overlay = "#26233a",
  muted = "#6e6a86",
  subtle = "#908caa",
  text = "#e0def4",
  love = "#eb6f92",
  gold = "#f6c177",
  rose = "#ebbcba",
  pine = "#31748f",
  foam = "#9ccfd8",
  iris = "#c4a7e7",
}

-- Apply consistent highlights
vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.surface })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.muted })
```

## Priority 2: Integration Improvements

### 2.1 Unified Project Management System

**Create central project manager**:
```fish
# fish/functions/p.fish
function p --description "Unified project manager"
    set -l project_dirs ~/projects ~/work ~/dotfiles
    set -l selected (fd -t d -d 2 . $project_dirs 2>/dev/null | \
                     sed "s|$HOME|~|g" | \
                     fzf --prompt="Project> " \
                         --preview='eza -la --color=always {}'
                         --preview-window=right:50%)
    
    if test -z "$selected"
        return 1
    end
    
    set -l project_path (echo $selected | sed "s|~|$HOME|g")
    set -l session_name (basename $project_path | tr . _)
    
    # Create or attach tmux session
    if not tmux has-session -t $session_name 2>/dev/null
        tmux new-session -d -s $session_name -c $project_path
        
        # Setup default layout
        tmux send-keys -t $session_name:0 "nvim" Enter
        tmux new-window -t $session_name:1 -n "shell"
        tmux new-window -t $session_name:2 -n "git" 
        tmux send-keys -t $session_name:2 "lazygit" Enter
        
        # Select first window
        tmux select-window -t $session_name:0
    end
    
    # Switch or attach
    if test -n "$TMUX"
        tmux switch-client -t $session_name
    else
        tmux attach-session -t $session_name
    end
end

# Add abbreviation
abbr -a pp p  # Quick access
```

**Integrate with Neovim**:
```lua
-- nvim/marvim/lua/plugins/project.lua
return {
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git", "package.json", "Cargo.toml", "go.mod" },
        silent_chdir = false,
      })
      
      -- Telescope integration
      require('telescope').load_extension('projects')
      
      -- Keybinding
      vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>",
        { desc = "Find project" })
    end,
  },
}
```

### 2.2 DRY Color Configuration

**Create single source of truth**:
```bash
# ~/.config/theme/rose-pine.env
export ROSE_PINE_BASE="#191724"
export ROSE_PINE_SURFACE="#1f1d2e"
export ROSE_PINE_OVERLAY="#26233a"
export ROSE_PINE_MUTED="#6e6a86"
export ROSE_PINE_SUBTLE="#908caa"
export ROSE_PINE_TEXT="#e0def4"
export ROSE_PINE_LOVE="#eb6f92"
export ROSE_PINE_GOLD="#f6c177"
export ROSE_PINE_ROSE="#ebbcba"
export ROSE_PINE_PINE="#31748f"
export ROSE_PINE_FOAM="#9ccfd8"
export ROSE_PINE_IRIS="#c4a7e7"
export ROSE_PINE_HIGHLIGHT_LOW="#21202e"
export ROSE_PINE_HIGHLIGHT_MED="#403d52"
export ROSE_PINE_HIGHLIGHT_HIGH="#524f67"
```

**Fish integration**:
```fish
# fish/conf.d/01_theme.fish
source ~/.config/theme/rose-pine.env

# Convert to fish variables
set -gx fish_color_normal $ROSE_PINE_TEXT
set -gx fish_color_command $ROSE_PINE_FOAM
set -gx fish_color_keyword $ROSE_PINE_PINE
set -gx fish_color_quote $ROSE_PINE_GOLD
set -gx fish_color_error $ROSE_PINE_LOVE
```

**Generate tmux theme**:
```fish
# scripts/generate-tmux-theme.fish
#!/usr/bin/env fish
source ~/.config/theme/rose-pine.env

echo "# Generated Rose Pine theme for tmux
set -g status-style \"bg=$ROSE_PINE_SURFACE,fg=$ROSE_PINE_TEXT\"
set -g window-status-style \"bg=$ROSE_PINE_SURFACE,fg=$ROSE_PINE_SUBTLE\"
set -g window-status-current-style \"bg=$ROSE_PINE_HIGHLIGHT_MED,fg=$ROSE_PINE_TEXT\"
set -g pane-border-style \"fg=$ROSE_PINE_HIGHLIGHT_MED\"
set -g pane-active-border-style \"fg=$ROSE_PINE_IRIS\"
set -g message-style \"bg=$ROSE_PINE_SURFACE,fg=$ROSE_PINE_TEXT\"
" > ~/.config/tmux/theme-generated.conf
```

## Priority 3: Enhanced Integration

### 3.1 Consistent Git Workflow

**Unified LazyGit access**:
```lua
-- Neovim
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>")
```

```bash
# Tmux
bind g display-popup -E -w 90% -h 90% lazygit
```

```fish
# Fish
function lg
    lazygit
end
abbr -a gg lg
```

### 3.2 Integrated Testing

**Create test runner wrapper**:
```fish
# fish/functions/test-run.fish
function test-run --description "Unified test runner"
    # Detect project type and run appropriate tests
    if test -f package.json
        if test -f node_modules/.bin/vitest
            vitest $argv
        else if test -f node_modules/.bin/jest
            jest $argv
        else
            npm test $argv
        end
    else if test -f Cargo.toml
        cargo test $argv
    else if test -f go.mod
        go test ./... $argv
    else if test -f pyproject.toml
        pytest $argv
    else if test -f Gemfile
        bundle exec rspec $argv
    else
        echo "No test runner detected"
        return 1
    end
end

# Tmux integration
function test-watch
    tmux split-window -h -p 40 "fish -c 'test-run --watch'"
end
```

### 3.3 Universal Help System

**Create unified keybinding documentation**:
```markdown
# ~/.config/help/keybindings.md

## Universal Navigation (Ctrl-hjkl)
Works across nvim and tmux with smart detection

| Key | Action | Context |
|-----|--------|---------|
| Ctrl-h | Navigate left | nvim split / tmux pane |
| Ctrl-j | Navigate down | nvim split / tmux pane |
| Ctrl-k | Navigate up | nvim split / tmux pane |
| Ctrl-l | Navigate right | nvim split / tmux pane |

## Resizing (Alt-hjkl)
| Key | Action | Tool |
|-----|--------|------|
| Alt-h | Decrease width | nvim / tmux |
| Alt-j | Decrease height | nvim / tmux |
| Alt-k | Increase height | nvim / tmux |
| Alt-l | Increase width | nvim / tmux |

## Window Management (Cmd-Alt-hjkl)
| Key | Action |
|-----|--------|
| Cmd-Alt-h | Focus window left |
| Cmd-Alt-j | Focus window down |
| Cmd-Alt-k | Focus window up |
| Cmd-Alt-l | Focus window right |
```

**Fish function to display help**:
```fish
function keys --description "Show keybinding help"
    glow ~/.config/help/keybindings.md | less -R
end
```

## Priority 4: Advanced Harmonization

### 4.1 Workspace Environment Management

**Project-specific configurations**:
```fish
# fish/functions/project-env.fish
function project-env --on-variable PWD
    # Look for project env file
    if test -f .envrc
        source .envrc
    else if test -f .env.fish
        source .env.fish
    end
    
    # Set project-specific variables
    if test -f package.json
        set -gx NODE_ENV development
    else if test -f Cargo.toml
        set -gx RUST_BACKTRACE 1
    end
end
```

### 4.2 Synchronized Clipboard

**Enhanced clipboard integration**:
```lua
-- nvim/marvim/lua/config/clipboard.lua
if vim.env.SSH_TTY then
  -- Use OSC 52 for SSH sessions
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end
```

### 4.3 Performance Monitoring

**Add startup time tracking**:
```fish
# fish/conf.d/99_performance.fish
if status is-interactive
    set -g fish_startup_time (math (date +%s%N) - $fish_start_time)
    if test $fish_startup_time -gt 100000000  # > 100ms
        echo "⚠️  Slow fish startup: "(math $fish_startup_time / 1000000)"ms"
    end
end
```

## Implementation Roadmap

### Week 1: Foundation
- [ ] Resolve Alt-hjkl conflicts
- [ ] Standardize Rose Pine theme
- [ ] Document existing setup

### Week 2: Integration
- [ ] Implement unified project manager
- [ ] Create DRY color system
- [ ] Consolidate git workflows

### Week 3: Enhancement
- [ ] Add help system
- [ ] Integrate testing
- [ ] Optimize performance

### Week 4: Polish
- [ ] Add workspace environments
- [ ] Enhance clipboard
- [ ] Create setup scripts

## Validation Metrics

### Success Criteria
1. **Navigation**: Seamless movement across all tools
2. **Consistency**: Uniform appearance and behavior
3. **Performance**: <300ms total startup time
4. **Discoverability**: Easy to learn and remember
5. **Maintainability**: DRY and modular configuration

### Testing Checklist
- [ ] Alt-hjkl works in all contexts
- [ ] Theme is consistent everywhere
- [ ] Project switching is seamless
- [ ] Help is easily accessible
- [ ] Clipboard works locally and remotely
- [ ] Performance meets targets

## Alternative Approaches

### Consider for Future
1. **WezTerm**: Built-in multiplexing, Lua config
2. **Zellij**: Modern tmux alternative
3. **Helix**: Modal editor with built-in LSP
4. **Nix/Home Manager**: Declarative configuration
5. **Chezmoi**: Template-based dotfile management

## Conclusion

The recommended harmonization focuses on:
1. **Immediate**: Fix conflicts and inconsistencies
2. **Near-term**: Unify common workflows
3. **Long-term**: Build integrated development environment

Priority should be given to changes that have the highest impact on daily workflow with the least disruption to existing muscle memory.