return {
  {
    'nvim-pack/nvim-spectre',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      require('spectre').setup {
        live_update = true,
        line_sep_start = '┌-----------------------------------------',
        result_padding = '¦  ',
        line_sep = '└-----------------------------------------',
      }
      require('config.keymaps').setup_spectre_keymaps()
    end,
  },
  {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup {}
      require('config.keymaps').setup_hlslens_keymaps()
    end,
  },
}
