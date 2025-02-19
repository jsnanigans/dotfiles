return {
  { "RRethy/vim-illuminate", lazy = false },
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },
  -- {
  --   "nvim-tree/nvim-web-devicons",
  --   enabled = false,
  -- },
}
