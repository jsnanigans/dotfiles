# Git Keybindings Reference

## Quick Reference
- **Leader key**: `<Space>` (default)
- **Git menu**: `<leader>g` - Opens interactive git menu

## Navigation

### Hunk Navigation
| Key | Description | Notes |
|-----|-------------|-------|
| `]h` | Next hunk | Supports count (e.g., `3]h` for 3rd next hunk) |
| `[h` | Previous hunk | Supports count |
| `]H` | Last hunk | Jump to the last change in file |
| `[H` | First hunk | Jump to the first change in file |

All navigation commands center the screen after jumping.

## Hunk Operations

### Stage/Reset Operations
| Key | Description | Mode |
|-----|-------------|------|
| `gha` | Apply (stage) current hunk | Normal |
| `ghr` | Reset current hunk | Normal |
| `<leader>hs` | Stage hunk | Normal/Visual |
| `<leader>hr` | Reset hunk | Normal/Visual |
| `<leader>hS` | Stage entire buffer | Normal |
| `<leader>hR` | Reset entire buffer | Normal |
| `<leader>hu` | Unstage buffer | Normal |

### Preview and Information
| Key | Description |
|-----|-------------|
| `<leader>hp` | Toggle diff overlay (preview all hunks) |
| `<leader>hi` | Show hunk information in floating window |
| `<leader>gs` | Show git status summary |

## Diff Operations

| Key | Description |
|-----|-------------|
| `<leader>hd` | Show diff with HEAD |
| `<leader>hD` | Show diff with specific commit (prompts for commit) |
| `<leader>hc` | Show staged changes |

## Git Blame

| Key | Description |
|-----|-------------|
| `<leader>hb` | Blame current line |
| `<leader>hB` | Blame entire file |

## Conflict Resolution

| Key | Description |
|-----|-------------|
| `]x` | Next conflict |
| `[x` | Previous conflict |
| `<leader>co` | Choose "ours" in conflict |
| `<leader>ct` | Choose "theirs" in conflict |
| `<leader>cb` | Choose both versions |
| `<leader>cn` | Delete entire conflict |

## Text Objects

| Key | Description | Example Usage |
|-----|-------------|---------------|
| `ih` | Inner hunk | `dih` - delete hunk content |
| `ah` | Around hunk (with context) | `yah` - yank hunk with context |

## Visual Mode

In visual mode, you can:
- `<leader>hs` - Stage selected lines
- `<leader>hr` - Reset selected lines

## Interactive Git Menu

Press `<leader>g` to open an interactive menu with quick access to common git operations:

```
Git Actions:
────────────
  s - Stage Hunk
  r - Reset Hunk
  S - Stage Buffer
  R - Reset Buffer
  u - Unstage
  p - Preview Hunks
  d - Diff
  b - Blame
  n - Next Hunk
  N - Prev Hunk
  q - Quit
```

## Tips

1. **Count Support**: Navigation commands support counts. For example:
   - `5]h` - Jump to the 5th next hunk
   - `2[h` - Jump back 2 hunks

2. **Visual Selection**: You can select specific lines in visual mode and stage/reset just those lines.

3. **Hunk Text Objects**: Use `vih` to select a hunk, then operate on it:
   - `yih` - Yank hunk content
   - `dih` - Delete hunk
   - `cih` - Change hunk

4. **Auto-centering**: All navigation commands automatically center the screen for better visibility.

5. **Floating Info**: `<leader>hi` shows detailed hunk information without leaving your current position.

## Configuration

These keybindings are defined in:
- Main config: `lua/config/plugins/git/mini-git.lua`
- Enhanced keys: `lua/utils/git/enhanced-keys.lua`

## Customization

To add or modify keybindings, edit the `enhanced-keys.lua` file in the utils/git directory. The setup is modular and easy to extend.