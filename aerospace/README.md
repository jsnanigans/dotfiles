# 🚀 Enhanced AeroSpace Configuration

This is an advanced AeroSpace setup with integrations, custom scripts, and quality-of-life improvements.

## Features

### 🎯 Core Enhancements
- **Smart Gaps**: Configurable window gaps (toggle with `aero gaps`)
- **Multiple Modes**: Main, Resize, Service, and Swap modes
- **Vim Navigation**: Consistent hjkl movement throughout
- **App Auto-Assignment**: Apps automatically move to designated workspaces
- **Floating Rules**: System windows float automatically

### 🔧 Integrations
- **JankyBorders**: Visual window borders that highlight active windows
- **Sketchybar**: Custom status bar showing workspaces (optional)
- **Fish Functions**: `aero` command for quick actions
- **FZF Window Picker**: Interactive window selection
- **Layout Presets**: Pre-configured layouts for common workflows

### 📜 Custom Scripts
- `layout-preset.sh`: Apply predefined window arrangements
- `window-picker.sh`: FZF-based window switcher
- `aero.fish`: Comprehensive helper functions

## Installation

1. **Install AeroSpace** (if not already installed):
   ```bash
   brew install --cask nikitabobko/tap/aerospace
   ```

2. **Run the extras installer**:
   ```bash
   ~/dotfiles/aerospace/install-extras.sh
   ```

3. **Choose your config**:
   ```bash
   # Use enhanced config
   cp ~/dotfiles/aerospace-enhanced.toml ~/.aerospace.toml
   
   # OR use the basic cleaned-up config
   cp ~/dotfiles/.aerospace.toml ~/.aerospace.toml
   ```

4. **Reload AeroSpace**:
   ```bash
   aerospace reload-config
   ```

## Usage

### Fish Helper Commands

The `aero` command provides quick access to common tasks:

```bash
aero layout dev    # Development layout (VSCode + Terminal)
aero layout web    # Web research (Browser + Notes)
aero layout focus  # Single window focus mode

aero pick          # Interactive window picker with FZF
aero ws            # Show workspace overview
aero focus chrome  # Focus window by app name
aero move 3        # Move current window to workspace 3
aero gaps          # Toggle gaps on/off
aero reload        # Reload configuration
```

### Keyboard Shortcuts

#### Main Mode
| Key | Action |
|-----|--------|
| `Alt+Enter` | Open Ghostty terminal |
| `Alt+Shift+Enter` | Open VS Code |
| `Alt+B` | Open browser |
| `Alt+H/J/K/L` | Focus window (vim-style) |
| `Alt+Shift+H/J/K/L` | Move window |
| `Alt+Ctrl+H/J/K/L` | Swap windows |
| `Alt+1-0` | Switch workspace |
| `Alt+Shift+1-0` | Move window to workspace |
| `Alt+/` | Cycle layouts |
| `Alt+F` | Fullscreen |
| `Alt+Z` | Toggle floating |
| `Alt+R` | Resize mode |
| `Alt+S` | Service mode |

#### Resize Mode (`Alt+R`)
| Key | Action |
|-----|--------|
| `H/J/K/L` | Resize by 20px |
| `Shift+H/J/K/L` | Resize by 100px |
| `-/=` | Smart resize |
| `B` | Balance sizes |
| `Esc` | Exit mode |

#### Service Mode (`Alt+S`)
| Key | Action |
|-----|--------|
| `1` | Reset layout |
| `2` | Horizontal split |
| `3` | Vertical split |
| `C` | Close window |
| `Shift+C` | Close all but current |
| `F` | Toggle floating |
| `R` | Reload config |
| `Esc` | Exit mode |

### Layout Presets

Use `aero layout [preset]` or create custom presets in `layout-preset.sh`:

- **dev**: VSCode (70%) + Terminal (30%)
- **web**: Browser (60%) + Notes (40%)
- **comm**: Communication apps in grid
- **focus**: Single window, fullscreen

### Workspace Organization

Default workspace assignments:
1. 🌐 Browsers
2. 💻 Development (VS Code)
3. 🖥️ Terminal (Ghostty)
4. 💬 Communication (Slack, Discord)
5. 📝 Notes (Obsidian)
6. 📚 Documentation
7. 🎬 Media
8. 🔧 Tools
9. 🎵 Music (Spotify)
10. 🗂️ Misc

## Customization

### Adding App Rules

Edit `~/.aerospace.toml` to add new app assignments:

```toml
[[on-window-detected]]
if.app-id = 'com.example.app'
run = 'move-node-to-workspace 5'
```

Find app IDs with:
```bash
aerospace list-windows --all --format '%{app-id} | %{app-name}'
```

### Creating Custom Layouts

Add to `layout-preset.sh`:

```bash
"custom")
    aerospace flatten-workspace-tree
    # Your custom layout logic here
    ;;
```

### Modifying Borders

Edit borders settings in `~/.aerospace.toml`:

```toml
after-startup-command = [
    'exec-and-forget borders active_color=0xffyourcolor inactive_color=0xffyourcolor width=3.0'
]
```

## Troubleshooting

- **Borders not showing**: Run `borders` manually to check for errors
- **Sketchybar issues**: Ensure "Displays have separate Spaces" is configured correctly
- **Config errors**: Run `aerospace reload-config` to see parsing errors
- **Find app IDs**: Use `aerospace list-windows --all`

## Additional Resources

- [AeroSpace Documentation](https://nikitabobko.github.io/AeroSpace/guide)
- [AeroSpace Commands Reference](https://nikitabobko.github.io/AeroSpace/commands)
- [Community Configs](https://github.com/nikitabobko/AeroSpace/discussions)
- [Sketchybar Wiki](https://felixkratz.github.io/SketchyBar/)

## Tips

1. **Quick Testing**: Use `aerospace reload-config` after any changes
2. **Debug Mode**: Check `~/.aerospace.log` for issues
3. **Backup Config**: Keep your working config backed up before major changes
4. **Monitor Setup**: Adjust gaps per monitor if using Sketchybar
5. **Performance**: Disable mouse-follows-focus if it feels sluggish