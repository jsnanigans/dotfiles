# 🚀 The Ultimate Ghostty Configuration Guide

A comprehensive collection of the best Ghostty terminal configurations, tips, tricks, and hidden features to supercharge your terminal experience.

## 📚 Table of Contents

- [Essential Configuration](#essential-configuration)
- [Visual Enhancements](#visual-enhancements)
- [Performance Optimizations](#performance-optimizations)
- [Advanced Features](#advanced-features)
- [Platform-Specific Tips](#platform-specific-tips)
- [Keybindings & Shortcuts](#keybindings--shortcuts)
- [Theme Gallery](#theme-gallery)
- [Pro Tips & Tricks](#pro-tips--tricks)

## Essential Configuration

### 🎯 The Perfect Starting Config

```ini
# Font Configuration
font-family = JetBrainsMono Nerd Font
font-size = 14
font-feature = -calt  # Disable ligatures if preferred
adjust-cell-height = 10%  # Better line spacing

# Theme
theme = tokyonight  # Or catppuccin, rose-pine, github-dark
# For automatic light/dark switching:
# theme = light:rose-pine-dawn,dark:rose-pine

# Window Appearance
background-opacity = 0.95
background-blur = 20
window-padding-x = 10
window-padding-y = 10
window-padding-balance = true
window-decoration = true

# Shell Integration
shell-integration = detect
shell-integration-features = cursor,sudo,title

# Clipboard
clipboard-read = allow
clipboard-write = allow
clipboard-trim-trailing-spaces = true
copy-on-select = clipboard

# Performance
window-vsync = true
```

## Visual Enhancements

### 🎨 Beautiful Window Styling

```ini
# Transparent Background with Blur (macOS/KDE)
background-opacity = 0.85
background-blur = 30
unfocused-split-opacity = 0.7

# Custom Padding for Clean Look
window-padding-x = 15,15  # Left, Right
window-padding-y = 15,15  # Top, Bottom
window-padding-balance = true
window-padding-color = extend

# Cursor Customization
cursor-style = block
cursor-style-blink = true
cursor-opacity = 0.8
cursor-color = #61AFEF
adjust-cursor-height = 35%
cursor-click-to-move = true

# Selection Colors
selection-invert-fg-bg = true
selection-background = #3E4452
selection-foreground = #ABB2BF
```

### 🖼️ Window Chrome Options

```ini
# macOS Titlebar Styles
macos-titlebar-style = tabs  # or transparent, native, hidden
macos-window-shadow = true
macos-titlebar-proxy-icon = visible

# Linux/GTK Options
gtk-tabs-location = top  # or bottom, left, right, hidden
gtk-titlebar = true
gtk-wide-tabs = true
adw-toolbar-style = raised  # or flat, raised-border
```

## Performance Optimizations

### ⚡ Speed & Responsiveness

```ini
# GPU Acceleration
window-vsync = false  # Disable for lower latency
custom-shader-animation = false  # Save CPU when using shaders

# Scrollback Optimization
scrollback-limit = 10000000  # 10MB scrollback

# Font Rendering
font-thicken = true  # macOS only
font-thicken-strength = 50
alpha-blending = linear-corrected  # Better text rendering

# Mouse
mouse-scroll-multiplier = 1.5
focus-follows-mouse = true
mouse-hide-while-typing = true
```

## Advanced Features

### 🔥 Power User Features

```ini
# Quick Terminal (Drop-down terminal)
quick-terminal-position = top
quick-terminal-screen = main
quick-terminal-animation-duration = 0.2
quick-terminal-autohide = true

# Window Management
window-save-state = always
window-inherit-working-directory = true
window-inherit-font-size = true
window-step-resize = true
resize-overlay = after-first
resize-overlay-position = center

# Advanced Shell Integration
shell-integration = detect
shell-integration-features = cursor,sudo,title
osc-color-report-format = 16-bit

# Image Protocol Support
image-storage-limit = 536870912  # 512MB for images

# Desktop Notifications
desktop-notifications = true
```

### 🎯 Split & Tab Management

```ini
# Splits
unfocused-split-opacity = 0.6
unfocused-split-fill = #1E1E2E
split-divider-color = #45475A

# Tabs
window-new-tab-position = current  # or end
gtk-tabs-location = top
```

## Platform-Specific Tips

### 🍎 macOS Exclusive Features

```ini
# macOS Specific
macos-non-native-fullscreen = visible-menu
macos-option-as-alt = true
macos-auto-secure-input = true
macos-secure-input-indication = true

# Custom App Icon
macos-icon = custom-style
macos-icon-ghost-color = #89B4FA
macos-icon-screen-color = #1E1E2E,#313244
macos-icon-frame = aluminum  # or beige, plastic, chrome

# Window Behavior
window-colorspace = display-p3
macos-titlebar-style = tabs
macos-window-shadow = true
```

### 🐧 Linux/GTK Features

```ini
# Linux Specific
linux-cgroup = single-instance
linux-cgroup-memory-limit = 2147483648  # 2GB limit
linux-cgroup-processes-limit = 256

# GTK Configuration
gtk-single-instance = desktop
gtk-adwaita = true
gtk-gsk-renderer = default
window-theme = ghostty  # Uses terminal colors for window

# Custom CSS
gtk-custom-css = ~/.config/ghostty/custom.css
```

## Keybindings & Shortcuts

### ⌨️ Essential Keybindings

```ini
# Window Management
keybind = cmd+n=new_window
keybind = cmd+t=new_tab
keybind = cmd+shift+d=new_split:right
keybind = cmd+d=new_split:down

# Navigation
keybind = cmd+shift+[=previous_tab
keybind = cmd+shift+]=next_tab
keybind = cmd+[=goto_split:previous
keybind = cmd+]=goto_split:next

# Font Size
keybind = cmd+plus=increase_font_size:1
keybind = cmd+minus=decrease_font_size:1
keybind = cmd+zero=reset_font_size

# Quick Actions
keybind = cmd+shift+p=toggle_quick_terminal
keybind = cmd+shift+enter=toggle_fullscreen
keybind = cmd+k=clear_screen
keybind = cmd+shift+c=copy_to_clipboard
keybind = cmd+shift+v=paste_from_clipboard

# Config Reload
keybind = cmd+shift+r=reload_config

# Jump to Prompt (requires shell integration)
keybind = cmd+up=jump_to_prompt:prev
keybind = cmd+down=jump_to_prompt:next
```

### 🎯 Advanced Key Sequences

```ini
# Leader Key Style (like tmux)
keybind = ctrl+a>n=new_window
keybind = ctrl+a>c=new_tab
keybind = ctrl+a>x=close_surface
keybind = ctrl+a>r=reload_config

# Global Keybinds (macOS only, requires accessibility)
keybind = global:cmd+shift+g=toggle_quick_terminal
```

## Theme Gallery

### 🎨 Popular Theme Configurations

```ini
# Catppuccin Mocha
theme = catppuccin-mocha
background = #1E1E2E
foreground = #CDD6F4

# Tokyo Night
theme = tokyonight
background = #1A1B26
foreground = #C0CAF5

# Rose Pine
theme = rose-pine
background = #191724
foreground = #E0DEF4

# GitHub Dark
theme = github-dark
background = #0D1117
foreground = #C9D1D9

# Gruvbox Dark
theme = gruvbox-dark
background = #282828
foreground = #EBDBB2

# One Dark Pro
theme = one-dark-pro
background = #282C34
foreground = #ABB2BF
```

### 🌈 Dynamic Theme Switching

```ini
# Automatic light/dark mode switching
theme = light:github-light,dark:github-dark

# Or with custom themes
theme = light:~/.config/ghostty/themes/my-light.conf,dark:~/.config/ghostty/themes/my-dark.conf
```

## Pro Tips & Tricks

### 💡 Hidden Features & Power Tips

1. **GPU-Accelerated Rendering**: Ghostty uses GPU acceleration by default, making it blazingly fast for scrolling and rendering.

2. **Shell Integration Magic**:
   - Automatic working directory inheritance for new tabs/splits
   - Smart close confirmation (no prompt if sitting at shell prompt)
   - Better prompt rendering when resizing

3. **Custom Shaders**: Add visual effects with GLSL shaders
   ```ini
   custom-shader = ~/.config/ghostty/shaders/retro-crt.glsl
   custom-shader-animation = true
   ```

4. **Font Fallback Chain**: Specify multiple fonts for better Unicode support
   ```ini
   font-family = JetBrainsMono Nerd Font
   font-family = Noto Color Emoji
   font-family = Symbols Nerd Font
   ```

5. **Smart Copy/Paste Protection**:
   ```ini
   clipboard-paste-protection = true
   clipboard-paste-bracketed-safe = true
   ```

6. **Window State Persistence**:
   ```ini
   window-save-state = always  # Restore tabs, splits, positions on restart
   ```

7. **Per-Surface Resource Limits** (Linux):
   ```ini
   linux-cgroup = always
   linux-cgroup-memory-limit = 1073741824  # 1GB per tab
   ```

8. **URL Clicking**: Hold Ctrl (Linux) or Cmd (macOS) and click URLs to open them
   ```ini
   link-url = true
   ```

### 🚀 Performance Tuning

- **For Low Latency**: Set `window-vsync = false`
- **For Better Text**: Use `alpha-blending = linear-corrected`
- **For Animations**: Enable `custom-shader-animation = always`
- **For Battery Life**: Disable unnecessary features like `background-blur`

### 🔧 Debugging & Development

```ini
# Enable debug logging
gtk-opengl-debug = true

# Test configurations without affecting default
ghostty --config-file=test.conf --config-default-files=false

# List available options
ghostty +list-fonts
ghostty +list-themes
ghostty +list-actions
ghostty +list-keybinds
```

## 📝 Example Complete Configuration

Here's a battle-tested configuration that combines the best of everything:

```ini
# Ghostty Ultimate Config
# Place in ~/.config/ghostty/config

# Font & Text
font-family = JetBrainsMono Nerd Font
font-size = 13
font-feature = -calt,-liga,-dlig  # Disable ligatures
adjust-cell-height = 15%
adjust-underline-position = 2
font-thicken = true

# Theme & Colors
theme = catppuccin-mocha
background-opacity = 0.92
background-blur = 25
minimum-contrast = 1.1

# Window
window-decoration = true
window-padding-x = 12
window-padding-y = 12
window-padding-balance = true
window-save-state = always
window-inherit-working-directory = true
window-inherit-font-size = true
resize-overlay = after-first

# Cursor
cursor-style = block
cursor-style-blink = true
cursor-opacity = 0.75
cursor-click-to-move = true

# Shell Integration
shell-integration = detect
shell-integration-features = cursor,sudo,title

# Clipboard
copy-on-select = clipboard
clipboard-trim-trailing-spaces = true
clipboard-paste-protection = true

# Performance
scrollback-limit = 10000000
window-vsync = true
mouse-scroll-multiplier = 1.5

# Keybinds
keybind = cmd+shift+enter=toggle_fullscreen
keybind = cmd+t=new_tab
keybind = cmd+w=close_surface
keybind = cmd+d=new_split:right
keybind = cmd+shift+d=new_split:down
keybind = cmd+[=goto_split:previous
keybind = cmd+]=goto_split:next
keybind = cmd+shift+c=copy_to_clipboard
keybind = cmd+shift+v=paste_from_clipboard
keybind = cmd+plus=increase_font_size:1
keybind = cmd+minus=decrease_font_size:1
keybind = cmd+0=reset_font_size
keybind = cmd+k=clear_screen
keybind = cmd+shift+r=reload_config

# Platform specific
macos-option-as-alt = true
macos-titlebar-style = tabs
gtk-single-instance = desktop
```

## 🎓 Resources & Links

- [Official Ghostty Documentation](https://ghostty.org/docs)
- [Ghostty GitHub Repository](https://github.com/ghostty-org/ghostty)
- [Community Themes](https://github.com/topics/ghostty-theme)
- [Config Generator Tool](https://github.com/zerebos/ghostty-config)

---

Remember: The best configuration is the one that works for your workflow. Start with the basics and gradually add features as you discover what enhances your productivity. Happy terminal customizing! 👻✨