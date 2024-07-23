return {
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ---@class trouble.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      -- focus = true,
      -- auto_refresh = false,
      -- preview = {
      --   type = 'split',
      --   relative = 'win',
      --   position = 'right',
      --   size = 0.5,
      -- },
    },
    keys = require('config.keymaps').setup_trouble_keymaps(),
  },
}
