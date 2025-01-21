-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
vim.g.mapleader = " "

vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold

vim.opt.shortmess:append 'I'

vim.opt.backup = true
vim.opt.cmdheight = 0
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"
vim.opt.mousescroll = "ver:2,hor:6"

vim.opt.number = true
vim.opt.relativenumber = true

-- vim.g.node_host_prog = "/Users/folke/.pnpm-global/5/node_modules/neovim/bin/cli.js"
-- vim.g.loaded_python3_provider = 0
-- vim.g.loaded_perl_provider = 0
-- vim.g.loaded_ruby_provider = 0
-- vim.g.loaded_node_provider = 0

-- padding top and bottom
vim.opt.scrolloff = 5
-- mouse support in all modes
vim.opt.mouse = 'a'

vim.opt.ignorecase = true
vim.opt.smartcase = true
-- incremental search
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.cursorline = true
-- text wrap
vim.opt.wrap = false

-- column ruler (can be overridden by per-language configs)
vim.opt.colorcolumn = nil

-- set tab and indents defaults (can be overridden by per-language configs)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.clipboard = 'unnamedplus'
-- sync with system clipboard (also see autocmds for text yank config)
-- vim.opt.clipboard = 'unnamedplus'

if require('util.version').is_neovim_0_10_0() then
  vim.opt.smoothscroll = true
end

-- TODO: pick from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
vim.opt.listchars = 'tab:▸ ,trail:·,nbsp:␣,extends:❯,precedes:❮' -- show symbols for whitespace

-- make all keymaps silent by default
local keymap_set = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    return keymap_set(mode, lhs, rhs, opts)
end

-- vim.g.lazyvim_python_lsp = "basedpyright"
-- vim.g.lazyvim_python_ruff = "ruff"
