return {
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {
        keymaps = {
          accept_suggestion = '<C-s>',
          accept_word = '<C-l>',
        },
      }
    end,
  },
  -- {
  --   'Exafunction/codeium.nvim',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'hrsh7th/nvim-cmp',
  --   },
  --   config = function()
  --     require('codeium').setup {}
  --   end,
  -- },

  -- {
  --   'jackMort/ChatGPT.nvim',
  --   event = 'VeryLazy',
  --   config = function()
  --     require('chatgpt').setup()
  --   end,
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'folke/trouble.nvim',
  --     'nvim-telescope/telescope.nvim',
  --   },
  -- },

  -- {
  --   'zbirenbaum/copilot.lua',
  --   cmd = 'Copilot',
  --   event = 'InsertEnter',
  --   config = function()
  --     local copilot = require 'copilot'
  --     local suggest = require 'copilot.suggestion'
  --     copilot.setup {
  --       suggestion = {
  --         enabled = true,
  --         auto_trigger = true,
  --       },
  --     }
  --
  --     vim.keymap.set('n', '<C-x>', function()
  --       -- suggest.toggle_auto_trigger()
  --     end)
  --     vim.keymap.set('i', '<C-s>', function()
  --       suggest.accept()
  --     end)
  --     -- vim.keymap.set('i', '<C-x>', function()
  --     --   suggest.prev()
  --     -- end)
  --     -- vim.keymap.set('i', '<C-c>', function()
  --     --   suggest.next()
  --     -- end)
  --     vim.keymap.set('i', '<C-z>', function()
  --       suggest.dismiss()
  --     end)
  --     vim.keymap.set('i', '<C-l>', function()
  --       suggest.accept_word()
  --     end)
  --   end,
  -- },

  -- {
  --   'CopilotC-Nvim/CopilotChat.nvim',
  --   branch = 'canary',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
  --     { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
  --   },
  --   config = function()
  --     require('CopilotChat').setup {
  --       debug = true, -- Enable debugging
  --       -- See Configuration section for rest
  --     }
  --   end,
  --   -- See Commands section for default commands if you want to lazy load on them
  -- },
}
