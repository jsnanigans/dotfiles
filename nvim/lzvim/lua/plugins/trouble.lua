return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    ---@class trouble.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      -- focus = true,
      -- auto_refresh = true,
      preview = {
        type = "split",
        relative = "win",
        position = "right",
        size = 0.5,
      },

      -- picker = {
      --   actions = {
      --     trouble_open = function(...)
      --       return require("trouble.sources.snacks").actions.trouble_open.action(...)
      --     end,
      --   },
      --   win = {
      --     input = {
      --       keys = {
      --         ["<a-t>"] = {
      --           "trouble_open",
      --           mode = { "n", "i" },
      --         },
      --       },
      --     },
      --   },
      -- },
    },
    keys = require("config.keymaps").setup_trouble_keymaps(),
  },
}
