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
    keys = {
      { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },
}
