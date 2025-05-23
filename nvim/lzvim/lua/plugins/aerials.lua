return {
	-- https://github.com/stevearc/aerial.nvim
  {
    'stevearc/aerial.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('aerial').setup {
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
        end,
      }
    end,
    keys = {
      { "<leader>ae", "<cmd>AerialToggle!<CR>", desc = "Aerial Toggle" },
    },
  },
}
