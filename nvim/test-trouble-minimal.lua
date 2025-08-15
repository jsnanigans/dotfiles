-- Minimal config to test Trouble with icons
-- Run with: nvim -u test-trouble-minimal.lua

-- Set up basic options
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy-test/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Define diagnostic signs with icons
local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " "
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = signs.Error,
      [vim.diagnostic.severity.WARN] = signs.Warn,
      [vim.diagnostic.severity.HINT] = signs.Hint,
      [vim.diagnostic.severity.INFO] = signs.Info,
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Setup plugins with lazy.nvim
require("lazy").setup({
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        default = true,
      })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({
        icons = {
          indent = {
            middle = "├╴",
            last = "└╴",
            fold_open = " ",
            fold_closed = " ",
            ws = "  ",
          },
          folder_closed = " ",
          folder_open = " ",
        },
      })
    end,
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
    }
  },
}, {
  root = vim.fn.stdpath("data") .. "/lazy-test",
})

-- Create a test file with errors
vim.cmd("edit test.lua")
vim.api.nvim_buf_set_lines(0, 0, -1, false, {
  "local a = 1",
  "local b = unknown_variable",
  "print(a + b)",
  "local c = another_error",
})

-- Set up fake diagnostics for testing
vim.defer_fn(function()
  local ns = vim.api.nvim_create_namespace("test")
  vim.diagnostic.set(ns, 0, {
    {
      lnum = 1,
      col = 0,
      message = "This is an error message with icon",
      severity = vim.diagnostic.severity.ERROR,
    },
    {
      lnum = 2,
      col = 0,
      message = "This is a warning message with icon",
      severity = vim.diagnostic.severity.WARN,
    },
    {
      lnum = 3,
      col = 0,
      message = "This is an info message with icon",
      severity = vim.diagnostic.severity.INFO,
    },
  })
  
  print("Test setup complete!")
  print("Press <leader>xx to open Trouble")
  print("You should see icons in the sign column and in Trouble window")
end, 500)