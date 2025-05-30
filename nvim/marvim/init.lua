-- MARVIM: Minimal Awesome Robust Vim
-- A poweruser's dream configuration

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

-- Core settings (before plugins)
require("config.options")
require("config.keymaps")

-- Plugin management with proper lazy configuration
require("lazy").setup("plugins", {
  -- Don't make everything lazy by default - let plugins decide
  defaults = {
    lazy = false, -- Plugins are not lazy by default
    version = false, -- Don't version lock plugins
  },
  -- Installation settings
  install = {
    missing = true, -- Install missing plugins on startup
    colorscheme = { "catppuccin", "habamax" }, -- Fallback colorschemes
  },
  -- UI configuration
  ui = {
    size = { width = 0.8, height = 0.8 },
    wrap = true,
    border = "rounded",
    backdrop = 60,
    title = "MARVIM Plugin Manager",
    title_pos = "center",
    icons = {
      cmd = " ",
      config = "",
      event = " ",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = " ",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  -- Update checking (disabled by default for performance)
  checker = {
    enabled = false, -- Don't auto-check for updates
    notify = false, -- Don't notify about updates
    frequency = 3600, -- Check every hour when enabled
  },
  -- Performance optimizations
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  -- Development settings
  dev = {
    path = "~/projects",
    patterns = {},
    fallback = false,
  },
  -- Profiling
  profiling = {
    loader = false,
    require = false,
  },
})

-- Post-plugin setup
require("config.autocmds")

-- Initialize project utilities for monorepo support
require("config.project-utils").setup()

-- Add keybinding to open lazy
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy plugin manager" })
