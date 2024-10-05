return {
  {
    "folke/persistence.nvim",
    lazy = false,
    config = function()
      require("persistence").setup {
        -- add any custom config here
        -- restore the session for the current directory
      }
      vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {})
      vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})
      vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], {})
    end,
  },
}
