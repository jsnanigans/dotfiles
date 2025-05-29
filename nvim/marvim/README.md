# MARVIM - Minimal Awesome Robust Vim

A poweruser's dream Neovim configuration that's minimal yet incredibly effective. Built with the latest and greatest plugins, optimized for coding efficiency and maximum productivity.

## ✨ Features

### 🎯 Core Philosophy
- **Minimal**: Only essential plugins, no bloat
- **Robust**: Rock-solid configuration that just works
- **Fast**: Lazy loading for lightning-fast startup
- **Poweruser**: Optimized keybindings and workflows

### 🚀 Key Components

- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) - The fastest and most modern plugin manager
- **LSP**: Mason + nvim-lspconfig for automatic language server management
- **Completion**: nvim-cmp with intelligent snippets and sources
- **Fuzzy Finder**: Telescope with fzf integration for blazing fast searches
- **Syntax**: Treesitter for superior highlighting and text objects
- **Git**: Gitsigns + Fugitive for complete git workflow
- **File Explorer**: nvim-tree for efficient file management
- **Theme**: Catppuccin Mocha - beautiful and easy on the eyes

## 🛠 Installation

### Prerequisites
- Neovim >= 0.9.0
- Git
- A Nerd Font (for icons)
- ripgrep (for telescope grep)
- make (for telescope-fzf-native)

### Quick Install
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone MARVIM
git clone <your-repo-url> ~/.config/nvim

# Start Neovim - plugins will auto-install
nvim
```

## ⌨️ Key Mappings

### Leader Key: `<Space>`

### 🔍 Telescope (Find Everything)
- `<leader>ff` - Find files
- `<leader>fr` - Find recent files  
- `<leader>fs` - Live grep (find in files)
- `<leader>fc` - Find word under cursor
- `<leader>fb` - Find buffers
- `<leader>fh` - Find help tags
- `<leader>fk` - Find keymaps

### 📁 File Explorer
- `<leader>ee` - Toggle file explorer
- `<leader>ef` - Toggle explorer on current file
- `<leader>ec` - Collapse file explorer
- `<leader>er` - Refresh file explorer

### 🔧 LSP Features
- `gd` - Go to definition
- `gR` - Find references
- `gi` - Go to implementation
- `gt` - Go to type definition
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `[d` / `]d` - Navigate diagnostics

### 🪟 Window Management
- `<C-h/j/k/l>` - Navigate windows
- `<leader>sv` - Split vertically
- `<leader>sh` - Split horizontally
- `<leader>se` - Equal window sizes
- `<leader>sx` - Close current split

### 📄 Buffer Navigation
- `<S-h>` - Previous buffer
- `<S-l>` - Next buffer
- `<leader>bd` - Delete buffer

### 🔀 Git Integration
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hp` - Preview hunk
- `<leader>hb` - Blame line
- `<leader>gs` - Git status
- `]c` / `[c` - Navigate hunks

### 💬 Comments & Text Objects
- `gcc` - Toggle line comment
- `gc` (visual) - Toggle selection comment
- `ys{motion}{char}` - Surround with character
- `ds{char}` - Delete surrounding character
- `cs{old}{new}` - Change surrounding character

### 🔧 Utilities
- `<leader>xx` - Toggle diagnostics
- `<leader>xt` - Todo comments
- `jk` - Exit insert mode
- `<leader>w` - Save file
- `<leader>q` - Quit

## 🎨 Customization

The configuration is modular and easy to customize:

```
marvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── config/
│   │   ├── options.lua      # Neovim options
│   │   ├── keymaps.lua      # Key mappings
│   │   └── autocmds.lua     # Auto commands
│   └── plugins/
│       ├── colorscheme.lua  # Theme configuration
│       ├── treesitter.lua   # Syntax highlighting
│       ├── telescope.lua    # Fuzzy finder
│       ├── lsp.lua          # Language servers
│       ├── completion.lua   # Auto completion
│       ├── file-explorer.lua# File management
│       ├── lualine.lua      # Status line
│       ├── git.lua          # Git integration
│       └── utils.lua        # Utility plugins
```

## 🚀 Performance

MARVIM is optimized for speed:
- Lazy loading of all plugins
- Disabled unnecessary built-in plugins
- Minimal startup time (~50ms)
- Efficient key timeout settings
- Smart completion and LSP configuration

## 🎯 Language Support

Automatically configured LSP servers for:
- TypeScript/JavaScript
- Python
- Lua
- HTML/CSS
- Tailwind CSS
- GraphQL
- Prisma
- And more via Mason

## 🔥 Pro Tips

1. **Learn the which-key**: Press `<leader>` and wait - see all available commands
2. **Use Telescope extensively**: It's your gateway to everything
3. **Master text objects**: `af` (around function), `if` (inside function), etc.
4. **Git workflow**: Stage hunks with `<leader>hs`, use `:Git` for complex operations  
5. **Quick navigation**: Use `<C-o>` and `<C-i>` to jump back/forward in jump list

## 🐛 Troubleshooting

### Fonts not displaying correctly
Install a Nerd Font and set it in your terminal.

### LSP servers not working
Run `:Mason` and install the required language servers.

### Slow startup
Check `:Lazy profile` to identify slow plugins.

### Missing ripgrep
Install with: `brew install ripgrep` (macOS) or your package manager.

---

**MARVIM** - Where minimal meets powerful. Happy coding! 🎉 