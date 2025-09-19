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

-- Setup migration warnings (Phase 4 - can be disabled after full migration)
-- Set vim.g.marvim_no_migration_warnings = true to disable
vim.defer_fn(function()
  local ok, warnings = pcall(require, "marvim.migration_warnings")
  if ok and warnings.setup then
    warnings.setup()
  end
end, 500)

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
