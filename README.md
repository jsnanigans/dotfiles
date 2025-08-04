# Dotfiles

Personal configuration files for Fish shell, tmux, and Ghostty terminal.

## Structure

```
dotfiles/
├── fish/                   # Fish shell configuration
│   ├── config.fish        # Main config file
│   ├── conf.d/            # Auto-loaded config modules
│   │   ├── 00_environment.fish  # Early environment vars
│   │   ├── 00_path.fish        # PATH configuration
│   │   ├── aliases.fish        # Command aliases
│   │   └── ...                 # Other configs
│   ├── functions/         # Custom functions
│   └── completions/       # Command completions
├── tmux/                  # Tmux configuration
│   ├── .tmux.conf        # Base config (oh-my-tmux)
│   ├── .tmux.conf.local  # User customizations
│   ├── keybindings.conf  # All keybindings
│   ├── theme.conf        # Rose Pine theme
│   └── tmux-which-key.conf # Which-key config
└── ghostty/              # Ghostty terminal
    └── config           # Terminal settings

```

## Key Features

### Fish Shell
- Organized configuration with modular `conf.d/` structure
- Smart PATH management with existence checking
- Lazy loading for rbenv, jenv, and thefuck
- Extensive aliases for common tasks
- MemoryBank integration
- Auto-launch tmux on login

### Tmux
- Rose Pine theme throughout
- Vim-style navigation (hjkl)
- Smart pane switching (Vim-aware)
- Extensive keybindings with `ctrl+b` prefix
- Plugin support via TPM:
  - tmux-copycat (enhanced search)
  - tmux-open (open files/URLs)
  - tmux-yank (better copy)
  - extrakto (fuzzy text extraction)
  - tmux-which-key (keybinding help)
- FZF integration for session/window switching
- Fish shell as default

### Ghostty
- Rose Pine theme
- JetBrains Mono font
- Tmux-style keybindings with `ctrl+a` prefix
- Fish shell integration
- Massive scrollback buffer (1M lines)

## Keybinding Reference

### Tmux (prefix: `ctrl+b`)
- **Panes**: h/j/k/l (navigate), H/J/K/L (resize), -/_ (split)
- **Windows**: c (create), n/p (next/prev), 1-9 (select)
- **Sessions**: s (list), C (create), f (find)
- **Copy**: Enter (copy mode), v (select), y (yank)
- **Search**: / (search up), ? (search down)

### Ghostty (prefix: `ctrl+a`)
- **Splits**: h/j/k/l (create), z (zoom)
- **Tabs**: n/p (navigate), c (create)
- **Config**: r (reload)

### Global shortcuts (no prefix)
- **Alt+h/j/k/l**: Quick pane switching
- **Alt+1-9**: Quick window switching
- **Alt+Space**: Cycle windows
- **Shift+Arrows**: Resize panes

## Installation

1. Clone to `~/dotfiles`
2. Symlink configs:
   ```bash
   ln -s ~/dotfiles/fish ~/.config/fish
   ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
   ln -s ~/dotfiles/tmux/.tmux.conf.local ~/.tmux.conf.local
   ln -s ~/dotfiles/ghostty/config ~/.config/ghostty/config
   ```
3. Install dependencies:
   - Fish shell: `brew install fish`
   - Tmux: `brew install tmux`
   - Ghostty: Download from ghostty.org
   - FZF: `brew install fzf`
   - Ripgrep: `brew install ripgrep`