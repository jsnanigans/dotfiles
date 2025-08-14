-- Core plugins that are essential for the configuration
-- Updated for snacks.nvim migration

return {
  -- Essential dependencies
  { "folke/lazy.nvim", version = false },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Session persistence - MIGRATED TO SNACKS.SESSION
  -- {
  --   "folke/persistence.nvim",
  --   event = "BufReadPre",
  --   keys = function()
  --     return require("config.keymaps").persistence_keys
  --   end,
  --   opts = {},
  -- },

  -- Better vim.ui - MIGRATED TO SNACKS.INPUT
  -- {
  --   "stevearc/dressing.nvim",
  --   lazy = true,
  --   init = function()
  --     vim.ui.select = function(...)
  --       require("lazy").load({ plugins = { "dressing.nvim" } })
  --       return vim.ui.select(...)
  --     end
  --     vim.ui.input = function(...)
  --       require("lazy").load({ plugins = { "dressing.nvim" } })
  --       return vim.ui.input(...)
  --     end
  --   end,
  -- },

  -- Which-key (kept - no full replacement in snacks)
  { import = "config.plugins.core.which-key" },
}
