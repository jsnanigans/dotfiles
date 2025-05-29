-- Core Neovim options optimized for power users
local opt = vim.opt

-- General
opt.mouse = "a"                       -- Enable mouse for all modes
opt.clipboard = "unnamedplus"         -- Use system clipboard
opt.swapfile = false                  -- Disable swap files
opt.completeopt = "menu,menuone,noselect,noinsert"

-- UI
opt.number = true                     -- Show line numbers
opt.relativenumber = true             -- Relative line numbers
opt.cursorline = true                 -- Highlight current line
opt.signcolumn = "yes"                -- Always show sign column
opt.colorcolumn = "100"               -- Show column at 100 chars
opt.scrolloff = 8                     -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8                 -- Keep 8 columns left/right of cursor
opt.termguicolors = true              -- True color support
opt.pumheight = 10                    -- Popup menu height

-- Indentation
opt.tabstop = 2                       -- Tab width
opt.shiftwidth = 2                    -- Indent width
opt.expandtab = true                  -- Use spaces instead of tabs
opt.smartindent = true                -- Smart auto-indenting
opt.breakindent = true                -- Maintain indent on wrapped lines

-- Search
opt.ignorecase = true                 -- Ignore case in search
opt.smartcase = true                  -- Case-sensitive if uppercase present
opt.incsearch = true                  -- Incremental search
opt.hlsearch = false                  -- Don't highlight search results

-- Performance
opt.updatetime = 250                  -- Faster completion
opt.timeoutlen = 300                  -- Faster key sequence timeout
opt.lazyredraw = true                 -- Lazy redraw for performance

-- Splits
opt.splitright = true                 -- Split vertical windows to right
opt.splitbelow = true                 -- Split horizontal windows below

-- Backup and undo
opt.backup = false                    -- No backup files
opt.writebackup = false               -- No backup during write
opt.undofile = true                   -- Persistent undo
opt.undolevels = 10000               -- More undo levels

-- Folding (using treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false                -- Don't fold by default

-- Miscellaneous
opt.conceallevel = 0                  -- Show concealed text
opt.fileencoding = "utf-8"            -- File encoding
opt.cmdheight = 1                     -- Command line height
opt.showmode = false                  -- Don't show mode (status line shows it)
opt.showtabline = 2                   -- Always show tabline
opt.wrap = false                      -- Don't wrap lines 