# Yazi Default Keybindings Reference

## Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `h` | Leave directory | Go to parent directory |
| `j` | Move down | Move cursor down |
| `k` | Move up | Move cursor up | 
| `l` | Enter directory | Enter directory or open file |
| `H` | Go back | Previous directory in history |
| `L` | Go forward | Next directory in history |
| `gg` | Go to top | Jump to first item |
| `G` | Go to bottom | Jump to last item |

## Scrolling
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-u` | Half page up | Scroll up half page |
| `Ctrl-d` | Half page down | Scroll down half page |
| `Ctrl-b` | Page up | Scroll up full page |
| `Ctrl-f` | Page down | Scroll down full page |
| `K` | Seek up 5 | Move up 5 lines |
| `J` | Seek down 5 | Move down 5 lines |

## Selection
| Key | Action | Description |
|-----|--------|-------------|
| `Space` | Toggle selection | Select/deselect current item |
| `v` | Visual mode | Enter selection mode |
| `V` | Visual mode (unset) | Enter unset mode |
| `Ctrl-a` | Select all | Select all files |
| `Ctrl-r` | Invert selection | Toggle all selections |

## File Operations
| Key | Action | Description |
|-----|--------|-------------|
| `o` | Open | Open with default application |
| `O` | Open interactive | Choose application to open |
| `Enter` | Open | Open file/directory |
| `y` | Yank | Copy selected files |
| `x` | Cut | Cut selected files |
| `p` | Paste | Paste files |
| `P` | Force paste | Paste with overwrite |
| `Y`/`X` | Unyank | Cancel yank/cut status |
| `d` | Delete | Move to trash |
| `D` | Delete permanently | Permanently delete |
| `-` | Symlink | Create absolute symlink |
| `_` | Relative symlink | Create relative symlink |
| `Ctrl--` | Hardlink | Create hardlink |

## File Management
| Key | Action | Description |
|-----|--------|-------------|
| `a` | Create | Create file/directory (end with `/` for dir) |
| `r` | Rename | Rename file (cursor before extension) |

## Search & Filter
| Key | Action | Description |
|-----|--------|-------------|
| `/` | Find | Find next file |
| `?` | Find previous | Find previous file |
| `n` | Next match | Go to next found |
| `N` | Previous match | Go to previous found |
| `f` | Filter | Filter files |
| `s` | Search (fd) | Search by name via fd |
| `S` | Search (rg) | Search by content via ripgrep |
| `Ctrl-s` | Cancel search | Cancel ongoing search |
| `z` | Zoxide | Jump via zoxide |
| `Z` | FZF | Jump via fzf |

## Display Modes (m prefix)
| Key | Action | Description |
|-----|--------|-------------|
| `ms` | Size mode | Show file sizes |
| `mp` | Permissions | Show permissions |
| `mb` | Birth time | Show creation time |
| `mm` | Modified time | Show modification time |
| `mo` | Owner | Show file owner |
| `mn` | None | Hide extra info |

## Copy to Clipboard (c prefix)
| Key | Action | Description |
|-----|--------|-------------|
| `cc` | Copy path | Copy full file path |
| `cd` | Copy directory | Copy directory path |
| `cf` | Copy filename | Copy filename |
| `cn` | Copy name | Copy name without extension |

## Sorting (, prefix)
| Key | Action | Description |
|-----|--------|-------------|
| `,m` | Sort modified | Sort by modified time |
| `,M` | Modified reverse | Reverse modified time |
| `,b` | Sort birth | Sort by birth time |
| `,B` | Birth reverse | Reverse birth time |
| `,e` | Sort extension | Sort by extension |
| `,E` | Extension reverse | Reverse extension |
| `,a` | Sort alphabetical | Sort A-Z |
| `,A` | Alphabetical reverse | Sort Z-A |
| `,n` | Sort natural | Natural sort |
| `,N` | Natural reverse | Reverse natural |
| `,s` | Sort size | Sort by file size |
| `,S` | Size reverse | Reverse size |
| `,r` | Sort random | Random order |

## Quick Jumps (g prefix)
| Key | Action | Description |
|-----|--------|-------------|
| `gh` | Go home | Jump to home directory |
| `gc` | Go config | Jump to ~/.config |
| `gd` | Go downloads | Jump to ~/Downloads |
| `g<Space>` | Interactive | Interactive directory jump |

## Tab Management
| Key | Action | Description |
|-----|--------|-------------|
| `t` | New tab | Create tab with current directory |
| `1-9` | Tab number | Switch to tab N |
| `[` | Previous tab | Switch to previous tab |
| `]` | Next tab | Switch to next tab |
| `{` | Swap left | Swap with previous tab |
| `}` | Swap right | Swap with next tab |

## Other Operations
| Key | Action | Description |
|-----|--------|-------------|
| `.` | Toggle hidden | Show/hide hidden files |
| `;` | Shell | Run shell command |
| `:` | Shell (block) | Run blocking shell command |
| `w` | Tasks | Show task manager |
| `Tab` | Spot | Preview file |
| `~` | Help | Show help |
| `q` | Quit | Exit yazi |
| `Q` | Quit (no cwd) | Exit without saving cwd |
| `Ctrl-c` | Close | Close tab or quit |
| `Ctrl-z` | Suspend | Suspend process |
| `Esc` | Escape | Exit mode/clear selection |

## Input Mode (Vim-like)
These keybindings work when editing filenames or in input fields:

| Key | Action | Description |
|-----|--------|-------------|
| `i` | Insert mode | Insert at cursor |
| `I` | Insert at start | Insert at line beginning |
| `a` | Append mode | Append after cursor |
| `A` | Append at end | Append at line end |
| `v` | Visual mode | Select text |
| `V` | Select all | Visual mode and select all |
| `r` | Replace | Replace single character |
| `h`/`l` | Move char | Move left/right |
| `b`/`w` | Word motion | Previous/next word |
| `e` | End of word | Jump to word end |
| `0`/`$` | Line start/end | Beginning/end of line |
| `^` | First non-space | First non-whitespace char |
| `u` | Undo | Undo last change |
| `Ctrl-r` | Redo | Redo last undo |
| `Ctrl-u` | Kill to start | Delete to line start |
| `Ctrl-k` | Kill to end | Delete to line end |
| `Ctrl-w` | Kill word | Delete previous word |
| `d` | Delete | Cut selection |
| `c` | Change | Cut and enter insert |
| `y` | Yank | Copy selection |
| `p`/`P` | Paste | Paste after/before cursor |

## Task Manager
| Key | Action | Description |
|-----|--------|-------------|
| `w` | Open/close | Toggle task manager |
| `j`/`k` | Navigate | Move up/down in list |
| `Enter` | Inspect | View task details |
| `x` | Cancel | Cancel task |
| `Esc` | Close | Exit task manager |

## Confirm Dialog
| Key | Action | Description |
|-----|--------|-------------|
| `y` | Yes | Confirm action |
| `n` | No | Cancel action |
| `Enter` | Submit | Confirm action |
| `Esc` | Cancel | Cancel dialog |

## Notes
- **Two-key combos**: Many commands use leader keys (`,` for sort, `g` for goto, `m` for display, `c` for clipboard)
- **Vim influence**: Navigation uses vim's `hjkl`, and input mode follows vim conventions
- **Context-aware**: Some keys work differently in different modes (e.g., `y` in normal vs input mode)
- **Arrow keys**: Also work for navigation alongside vim keys
- **Help available**: Press `~` or `F1` in most contexts for help