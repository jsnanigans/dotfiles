# Enhanced Git Workflow

## Overview
Complete git workflow integration for nvim using Snacks picker exclusively, with hunk management and terminal commands.

## Components

### 1. Nvim Git Pickers (`lua/utils/git/pickers.lua`)
- Custom Snacks pickers for git operations
- Files changed vs branch comparison
- Hunk visualization and navigation
- Direct commit from nvim
- No external dependencies (uses Snacks only)

### 2. Git Keymaps (`lua/utils/git/keymaps.lua`)
- Comprehensive keybindings for git operations
- Integration with mini.diff for hunk navigation
- LazyGit integration via Snacks

### 3. Terminal Commands (Fish functions)
- `gbdiff [branch]` - Show files changed vs branch
- `ghunks` - Display all hunks with status
- `gsi` - Interactive staging with fzf
- `gqc [message]` - Quick commit
- `ghelp` - Show all git commands

## Keybindings

### Navigation
- `[h`/`]h` - Previous/Next hunk
- `[H`/`]H` - First/Last hunk
- `ih` - Inner hunk (text object)

### Staging Operations
- `ghs` - Stage hunk at cursor
- `ghu` - Unstage hunk
- `ghr` - Reset hunk
- `<leader>gA` - Stage all changes
- `<leader>gU` - Unstage all changes

### Git Pickers
- `<leader>gd` - Files changed vs release branch
- `<leader>gD` - Files changed vs custom branch
- `<leader>gh` - Interactive hunks picker
- `<leader>gs` - Git status (Snacks)
- `<leader>gc` - Git commits log (Snacks)

### Git Actions
- `<leader>gC` - Commit staged changes
- `<leader>gb` - Blame current line
- `<leader>gB` - Blame buffer
- `<leader>go` - Open in browser (Snacks)
- `<leader>gl` - LazyGit
- `<leader>gL` - LazyGit log
- `<leader>gf` - LazyGit file history

### Picker Actions
Inside the custom pickers:
- `<Enter>` - Open file or jump to hunk
- `<Ctrl-s>` - Stage file/hunk
- `<Ctrl-u>` - Unstage file/hunk
- `<Ctrl-r>` - Reset hunk (hunks picker only)
- `<Ctrl-d>` - Show diff

## Terminal Abbreviations

### Basic Operations
- `gst` - Git status
- `gaa` - Stage all changes
- `gap` - Interactive patch staging
- `gdc` - Show cached diff
- `gdst` - Show diff statistics

### Custom Commands
- `gbdiff` - Files changed vs release
- `ghunks` - Show all hunks
- `gsi` - Stage with fzf
- `gqc` - Quick commit
- `ghelp` - Show help

## Configuration Files

- `nvim/marvim/lua/utils/git/pickers.lua` - Custom picker implementations
- `nvim/marvim/lua/utils/git/keymaps.lua` - Keybinding setup
- `nvim/marvim/lua/utils/git/enhanced-keys.lua` - Additional git keymaps
- `nvim/marvim/lua/config/plugins/git/mini-git.lua` - Mini.diff configuration
- `fish/functions/git-*.fish` - Terminal git functions
- `fish/conf.d/git.fish` - Git abbreviations

## Usage Examples

### Compare with Release Branch
```vim
:GitFilesVsBranch
" or press <leader>gd
```

### Interactive Hunk Management
```vim
" Navigate to a change
]h
" Stage the hunk
ghs
" Or use the hunks picker
<leader>gh
```

### Quick Commit from Terminal
```bash
gqc "Fix: resolved authentication issue"
```

### Interactive Staging
```bash
gsi
# Use fzf to select files
# Ctrl-S to stage, Ctrl-U to unstage
```

## Features

1. **Visual Status Indicators**
   - ✓ Staged (green)
   - ● Modified (yellow)  
   - ? Untracked (blue)
   - ○ Branch diff (magenta)

2. **Smart Branch Comparison**
   - Default comparison against `release` branch
   - Custom branch selection
   - Includes uncommitted changes

3. **Integrated Workflow**
   - Seamless nvim and terminal integration
   - Consistent keybindings
   - Visual feedback for all operations

## Tips

- Use `<leader>g?` in nvim to see all git keybindings
- Type `ghelp` in terminal for command reference
- The pickers automatically refresh after staging/unstaging
- All changes are shown with clear status indicators