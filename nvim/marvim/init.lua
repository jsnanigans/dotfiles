-- Initialize MARVIM framework
require("marvim").setup({
  optimize = true,  -- Enable performance optimizations
  config = {
    -- Framework configuration can be customized here
    features = {
      copilot = false,
      snippets = true,
      dap = true,
      testing = true,
      lsp = true,
      treesitter = true,
      telescope = true,
      git = true,
    },
    lsp = {
      format_on_save = true,
      virtual_text = "mini",
      diagnostic_float = true,
    },
    ui = {
      theme = "nord",
      transparency = false,
      icons = true,
      animate = true,
      border = "rounded",
    },
  },
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- Load configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
