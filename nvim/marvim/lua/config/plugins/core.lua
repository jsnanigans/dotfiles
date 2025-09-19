-- Core plugins that are essential for the configuration
-- Migrated to use MARVIM framework for better error handling and consistency

local M = require("marvim.plugin_helper")

return {
  -- Essential dependencies
  { "folke/lazy.nvim", version = false },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Session persistence (snacks.nvim doesn't have session management)
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    keys = function()
      local keymaps = M.safe_require("config.keymaps")
      return keymaps and keymaps.persistence_keys or {}
    end,
    opts = {},
  },

  -- Better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        local lazy = M.safe_require("lazy")
        if lazy then
          lazy.load({ plugins = { "dressing.nvim" } })
        end
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        local lazy = M.safe_require("lazy")
        if lazy then
          lazy.load({ plugins = { "dressing.nvim" } })
        end
        return vim.ui.input(...)
      end
    end,
  },

  -- Which-key (kept separate due to size)
  { import = "config.plugins.core.which-key" },
}
