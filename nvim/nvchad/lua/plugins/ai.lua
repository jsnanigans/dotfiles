return {
  {
    'supermaven-inc/supermaven-nvim',
    -- load when a file is opened
    event = 'BufReadPre',
    config = function()
      require('supermaven-nvim').setup {
        keymaps = {
          accept_suggestion = '<C-s>',
          accept_word = '<C-l>',
        },
        log_level = "info", -- set to "off" to disable logging completely
        -- disable_inline_comletion = true, -- disables inline completion for use with cmp
        -- disable_keymaps = true, -- disables built in keymaps for more manual control
      }
    end,
  }

}
