# Implementation Guide

## Quick Start Checklist

### Day 1: Critical Fixes (30 minutes)
- [ ] Backup current configurations
- [ ] Fix Alt-hjkl conflict in AeroSpace
- [ ] Test navigation across all tools
- [ ] Document any issues

### Day 2: Theme Unification (1 hour)
- [ ] Install Rose Pine for Neovim
- [ ] Update nvim colorscheme
- [ ] Verify color consistency
- [ ] Adjust any custom highlights

### Day 3-7: Core Integration (2-3 hours)
- [ ] Implement unified project manager
- [ ] Create central theme configuration
- [ ] Set up consistent git workflow
- [ ] Add basic help system

## Detailed Implementation Steps

### Step 1: Backup Current Configuration
```bash
# Create backup branch
cd ~/dotfiles
git checkout -b backup-$(date +%Y%m%d)
git add -A
git commit -m "Backup before harmonization"

# Create physical backup
cp -r ~/dotfiles ~/dotfiles.backup.$(date +%Y%m%d)
```

### Step 2: Fix Keybinding Conflicts

#### 2.1 Update AeroSpace Configuration
```bash
# Edit .aerospace.toml
nvim ~/.aerospace.toml
```

Replace window focus bindings:
```toml
# OLD (lines 80-84)
alt-h = 'focus left'
alt-j = 'focus down'
alt-k = 'focus up'
alt-l = 'focus right'

# NEW
cmd-alt-h = 'focus left'
cmd-alt-j = 'focus down'
cmd-alt-k = 'focus up'
cmd-alt-l = 'focus right'
```

Update window movement bindings:
```toml
# OLD (lines 86-90)
alt-shift-h = 'move left'
alt-shift-j = 'move down'
alt-shift-k = 'move up'
alt-shift-l = 'move right'

# NEW
cmd-alt-shift-h = 'move left'
cmd-alt-shift-j = 'move down'
cmd-alt-shift-k = 'move up'
cmd-alt-shift-l = 'move right'
```

#### 2.2 Reload AeroSpace
```bash
# Reload configuration
aerospace reload-config

# Test new bindings
# Try Cmd+Alt+h/j/k/l for window focus
# Try Alt+h/j/k/l in tmux/nvim for resizing
```

### Step 3: Unify Theme Configuration

#### 3.1 Install Rose Pine for Neovim
```lua
-- nvim/marvim/lua/plugins/colorscheme.lua
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "main",
        dark_variant = "main",
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = false,
        disable_float_background = false,
        disable_italics = false,
        
        groups = {
          background = "base",
          background_nc = "_experimental_nc",
          panel = "surface",
          panel_nc = "base",
          border = "highlight_med",
          comment = "muted",
          link = "iris",
          punctuation = "subtle",
        },
        
        highlight_groups = {
          ColorColumn = { bg = "rose" },
          CursorLine = { bg = "foam", blend = 10 },
          StatusLine = { fg = "love", bg = "love", blend = 10 },
        }
      })
      
      vim.cmd("colorscheme rose-pine")
    end,
  },
}
```

#### 3.2 Update Neovim to Load New Theme
```lua
-- nvim/marvim/init.lua
-- Ensure the colorscheme loads
vim.cmd.colorscheme("rose-pine")
```

#### 3.3 Test Theme Consistency
```bash
# Open nvim and verify Rose Pine is active
nvim

# Check theme in different contexts
:Telescope find_files
:LazyGit
:split
```

### Step 4: Create Unified Project Manager

#### 4.1 Create Project Function
```bash
# Create new function file
nvim ~/.config/fish/functions/p.fish
```

Add the function:
```fish
function p --description "Unified project manager"
    # Define project directories
    set -l project_dirs ~/projects ~/work ~/dotfiles
    
    # Use fd and fzf to select project
    set -l selected (fd -t d -d 2 . $project_dirs 2>/dev/null | \
                     fzf --prompt="Project> " \
                         --header="Select a project" \
                         --preview='eza -la --color=always {}' \
                         --preview-window=right:50%)
    
    if test -z "$selected"
        return 1
    end
    
    set -l session_name (basename $selected | tr . _)
    
    # Create or attach tmux session
    if not tmux has-session -t $session_name 2>/dev/null
        tmux new-session -d -s $session_name -c $selected
        tmux send-keys -t $session_name:0 "nvim" Enter
    end
    
    # Switch or attach
    if test -n "$TMUX"
        tmux switch-client -t $session_name
    else
        tmux attach-session -t $session_name
    end
end
```

#### 4.2 Add Keybinding
```fish
# Add to ~/.config/fish/conf.d/keybindings.fish
bind \cp p  # Ctrl-p for project switcher
```

### Step 5: Create Central Theme Configuration

#### 5.1 Create Theme Directory
```bash
mkdir -p ~/.config/theme
```

#### 5.2 Create Theme File
```bash
nvim ~/.config/theme/rose-pine.sh
```

Add theme colors:
```bash
#!/usr/bin/env bash
# Rose Pine Theme Colors

# Base colors
export ROSE_PINE_BASE="#191724"
export ROSE_PINE_SURFACE="#1f1d2e"
export ROSE_PINE_OVERLAY="#26233a"
export ROSE_PINE_MUTED="#6e6a86"
export ROSE_PINE_SUBTLE="#908caa"
export ROSE_PINE_TEXT="#e0def4"

# Accent colors
export ROSE_PINE_LOVE="#eb6f92"
export ROSE_PINE_GOLD="#f6c177"
export ROSE_PINE_ROSE="#ebbcba"
export ROSE_PINE_PINE="#31748f"
export ROSE_PINE_FOAM="#9ccfd8"
export ROSE_PINE_IRIS="#c4a7e7"

# Highlight colors
export ROSE_PINE_HIGHLIGHT_LOW="#21202e"
export ROSE_PINE_HIGHLIGHT_MED="#403d52"
export ROSE_PINE_HIGHLIGHT_HIGH="#524f67"
```

#### 5.3 Source Theme in Fish
```fish
# Add to ~/.config/fish/config.fish
if test -f ~/.config/theme/rose-pine.sh
    bass source ~/.config/theme/rose-pine.sh
end
```

### Step 6: Consistent Git Integration

#### 6.1 Add LazyGit Binding to Tmux
```bash
# Add to ~/.tmux.conf
bind-key g display-popup -E -w 90% -h 90% "lazygit"
```

#### 6.2 Create Fish Alias
```fish
# Add to ~/.config/fish/conf.d/aliases.fish
alias lg='lazygit'
abbr -a gg lazygit
```

### Step 7: Create Help System

#### 7.1 Create Help Directory
```bash
mkdir -p ~/.config/help
```

#### 7.2 Create Keybinding Reference
```bash
nvim ~/.config/help/keys.md
```

Add content:
```markdown
# Universal Keybindings

## Navigation (Works Everywhere)
- `Ctrl-h/j/k/l` - Navigate splits/panes
- `Alt-h/j/k/l` - Resize splits/panes  
- `Cmd-Alt-h/j/k/l` - Focus OS windows

## Leaders and Prefixes
- Neovim: `Space`
- Tmux: `Ctrl-b`
- Ghostty: `Ctrl-a`
- AeroSpace: `Cmd-Alt`

## Quick Commands
- `p` - Project switcher (fish)
- `tm` - Tmux session manager
- `lg` - LazyGit
```

#### 7.3 Create Help Function
```fish
# ~/.config/fish/functions/keys.fish
function keys --description "Show keybinding help"
    if command -q glow
        glow ~/.config/help/keys.md
    else
        cat ~/.config/help/keys.md
    end
end
```

### Step 8: Testing and Validation

#### 8.1 Test Navigation
```bash
# Test each navigation type
1. Open tmux
2. Split panes (prefix + -, prefix + _)
3. Open nvim in one pane
4. Create nvim splits (:vsplit, :split)
5. Test Ctrl-hjkl navigation (should work seamlessly)
6. Test Alt-hjkl resizing
7. Test Cmd-Alt-hjkl for OS windows
```

#### 8.2 Test Project Switching
```bash
# Test project manager
1. Run 'p' command
2. Select a project
3. Verify tmux session created
4. Verify nvim opened
5. Switch projects and verify context preserved
```

#### 8.3 Test Theme Consistency
```bash
# Visual inspection
1. Open nvim - should show Rose Pine
2. Check tmux status bar - Rose Pine colors
3. Check fish prompt - Rose Pine colors
4. Open LazyGit - consistent theme
```

### Step 9: Troubleshooting

#### Common Issues and Solutions

**Issue**: Alt-hjkl still not working
```bash
# Check if AeroSpace is capturing keys
aerospace list-bindings | grep alt-h

# Ensure config reloaded
aerospace reload-config
```

**Issue**: Rose Pine not loading in nvim
```lua
-- Check if plugin installed
:Lazy
-- Look for rose-pine in the list

-- Try manual load
:colorscheme rose-pine
```

**Issue**: Project switcher not finding directories
```fish
# Check fd is installed
which fd

# Install if missing
brew install fd

# Test fd command
fd -t d -d 2 . ~/
```

### Step 10: Commit Changes

```bash
# Stage changes
git add -A

# Commit with descriptive message
git commit -m "Harmonize terminal tools configuration

- Fix Alt-hjkl conflicts between AeroSpace, tmux, and nvim
- Unify theme to Rose Pine across all tools
- Add unified project manager function
- Create central theme configuration
- Add consistent git integration
- Implement help system for keybindings"

# Push to remote
git push origin main
```

## Performance Validation

### Measure Startup Times
```fish
# Fish startup
time fish -c exit

# Neovim startup
time nvim --headless +qa

# Full stack startup
time fish -c "tmux new-session -d; nvim --headless +qa"
```

### Expected Results
- Fish: <50ms
- Neovim: <150ms
- Full stack: <300ms

## Rollback Plan

If issues arise:
```bash
# Restore from git backup
git checkout backup-$(date +%Y%m%d) -- .

# Or restore from physical backup
cp -r ~/dotfiles.backup.$(date +%Y%m%d)/* ~/dotfiles/

# Reload configurations
source ~/.config/fish/config.fish
tmux source ~/.tmux.conf
aerospace reload-config
```

## Next Steps

After successful implementation:
1. Monitor for any workflow disruptions
2. Fine-tune keybindings based on usage
3. Add more project templates
4. Extend help documentation
5. Consider advanced features from recommendations

## Success Metrics

- [ ] All navigation keys work without conflicts
- [ ] Theme is visually consistent
- [ ] Project switching is fast (<1s)
- [ ] Help is accessible via 'keys' command
- [ ] No performance degradation
- [ ] Git workflow is streamlined

## Support Resources

- Rose Pine Theme: https://rosepinetheme.com
- Smart Splits: https://github.com/mrjones2014/smart-splits.nvim
- Fish Documentation: https://fishshell.com/docs
- Tmux Manual: https://man.openbsd.org/tmux