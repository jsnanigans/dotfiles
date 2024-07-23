return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      local opts = require('config.keymaps').setup_whichkey()
      require('which-key').setup(opts)
    end,
  },
}
