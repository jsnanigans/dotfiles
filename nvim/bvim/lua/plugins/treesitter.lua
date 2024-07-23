return {
  -- {
  --   'lepture/vim-jinja',
  --   dependencies = {
  --     {
  --       'pearofducks/ansible-vim',
  --       build = './UltiSnips/generate.sh',
  --       lazy = false,
  --     },
  --   },
  --   lazy = false,
  -- },
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    build = ':TSUpdate',
    config = function()
      local config = require 'nvim-treesitter.configs'
      config.setup {
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = { 'lua', 'vim', 'vimdoc', 'typescript', 'markdown', 'markdown_inline' },
      }
    end,
  },

  -- {
  --   'nvim-treesitter/nvim-treesitter-context',
  --   event = 'VeryLazy',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter', lazy = true },
  --   config = function()
  --     require('treesitter-context').setup {
  --       max_lines = 6,
  --     }
  --   end,
  -- },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter', lazy = true },
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = { query = '@class.outer', desc = 'Next class start' },
              --
              -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
              [']o'] = '@loop.*',
              -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
              --
              -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
              -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
              [']z'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
              -- [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
            goto_next = {
              [']i'] = '@conditional.outer',
            },
            goto_previous = {
              ['[i'] = '@conditional.outer',
            },
          },
          lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
              ['<leader>df'] = '@function.outer',
              ['<leader>dF'] = '@class.outer',
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              -- ['ac'] = '@class.outer',
              -- ['ic'] = '@class.inner',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
              ['ab'] = '@block.outer',
              ['ib'] = '@block.inner',
              ['ap'] = '@parameter.outer',
              ['ip'] = '@parameter.inner',
              ['ai'] = '@conditional.outer',
              ['ii'] = '@conditional.inner',
              ['aa'] = '@call.outer',
              ['ia'] = '@call.inner',
            },
            selection_modes = {
              -- ['@parameter.outer'] = 'v', -- charwise
              -- ['@function.outer'] = 'V', -- linewise
              -- ['@class.outer'] = '<c-v>', -- blockwise
            },
          },
        },
      }

      local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

      -- vim way: ; goes to the direction you were moving.
      -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
      vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)
    end,
  },
}
