# Keybinding Conflict Resolution

## Issue: Alt-hjkl Conflicts
Three systems were competing for the same Alt-hjkl keybindings:
- **AeroSpace**: Window focus (OS-level)
- **tmux**: Pane switching 
- **nvim**: Window resizing

## Resolution Applied

### Priority Hierarchy (Based on Usage Frequency)
1. **nvim** (Most used) → Gets priority for Alt-hjkl
2. **tmux** (Frequently used) → Uses Ctrl-hjkl (already configured)
3. **AeroSpace** (Less frequent) → Moved to Alt-Shift-hjkl

### Changes Made

#### 1. nvim (KEEPS ALT-HJKL)
- **Alt-hjkl**: Window resizing (kept as-is - highest priority)
- **Alt-j/k**: Move lines up/down (kept as-is)
- **Ctrl-hjkl**: Window navigation (unchanged, vim-tmux aware)

#### 2. tmux (USES CTRL-HJKL)
- **REMOVED Alt-hjkl**: Avoided conflict
- **Ctrl-hjkl**: Smart pane switching (vim-aware) - primary method
- **Prefix + hjkl**: Pane navigation with prefix - still available

#### 3. AeroSpace (MOVED TO ALT-SHIFT)
- **Alt-Shift-hjkl**: Window focus navigation (changed from Alt-hjkl)
- **Alt-Cmd-hjkl**: Window movement (changed from Alt-Shift-hjkl)

## Final Keybinding Map

| Function | nvim | tmux | AeroSpace |
|----------|------|------|-----------|
| Navigate | Ctrl-hjkl (splits) | Ctrl-hjkl (panes) | Alt-Shift-hjkl (windows) |
| Resize | Alt-hjkl | Prefix+HJKL | - |
| Move | Alt-j/k (lines) | - | Alt-Cmd-hjkl (windows) |

## Testing Checklist

- [ ] AeroSpace: Alt-hjkl switches between windows
- [ ] tmux: Ctrl-hjkl switches between panes (vim-aware)
- [ ] nvim: Ctrl-hjkl navigates between splits
- [ ] nvim: Alt-Shift-hjkl resizes splits
- [ ] nvim: Alt-Shift-j/k moves lines up/down
- [ ] No conflicts when using nvim inside tmux

## Benefits

1. **Clear hierarchy**: OS-level gets priority for Alt modifiers
2. **Consistency**: Ctrl-hjkl for navigation across tmux/nvim
3. **No conflicts**: Each system has unique keybinding space
4. **Muscle memory**: Similar patterns (hjkl) for navigation