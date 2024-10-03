return {
  {
    'stevearc/overseer.nvim',
    config = function()
      require('overseer').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        -- view = 'float',
        -- view = 'mini',
      }
    end,
  },
}
