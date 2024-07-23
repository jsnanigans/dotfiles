return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'L3MON4D3/LuaSnip' },
      -- { 'hrsh7th/cmp-cmdline' },
      -- { 'hrsh7th/vim-vsnip' },
      -- { 'hrsh7th/vim-vsnip-integ' },
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-h>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          ['<C-j>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ['<C-Space>'] = cmp.mapping.complete(),
          -- ['<C-x>'] = cmp.mapping.complete {
          --   config = { sources = cmp.config.sources {
          --     { name = 'luasnip' },
          --   } },
          -- },
          -- ['<C-x>'] = cmp.mapping.complete {
          --   config = { sources = cmp.config.sources {
          --     { name = 'copilot' },
          --   } },
          -- },
          ['<C-x>'] = cmp.mapping.complete {
            config = { sources = cmp.config.sources {
              { name = 'supermaven' },
            } },
          },
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
        experimental = {
          -- ghost_text = true,
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.abbr = string.sub(vim_item.abbr, 1, 35)
            return vim_item
          end,
        },
      }
    end,
  },
  -- {
  --   'zbirenbaum/copilot-cmp',
  --   config = function()
  --     require('copilot_cmp').setup()
  --   end,
  -- },
}
