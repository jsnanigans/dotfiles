-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local util = require("util")

util.cowboy()

-- change word with <c-c>
vim.keymap.set({ "n", "x" }, "<C-c>", "<cmd>normal! ciw<cr>a")
vim.keymap.set({ "n", "x" }, "-", "<cmd>Oil<cr>a")
