return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      }

      local hooks = require 'ibl.hooks'
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#292c09' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#063c3c' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#2c1b0a' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#083d4c' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#1a542e' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#063c3c' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#083d4c' })
      end)

      require('ibl').setup { indent = { highlight = highlight } }
    end,
  },
}
