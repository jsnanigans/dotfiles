return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    -- opts = {
    -- },
    -- init = function()
    --   -- TODO: set colorscheme based on system/terminal dark/light mode
    --   -- Also see utils/colorscheme.lua
    -- end,
    config = function()
      require('tokyonight').setup {
        -- transparent = true,
        styles = {
          comments = { italic = true },
          keywords = {
            italic = true,
          },
          functions = {
            bold = true,
          },
          variables = {
            bold = true,
          },
        },
        -- style = 'night',
      }
      vim.cmd.colorscheme 'tokyonight'
    end,
  },
  --
  -- {
  --   "catppuccin/nvim",
  --   enabled = false,
  --   name = "catppuccin",
  -- },

  -- {
  --   "rose-pine/neovim",
  --   -- enabled = false,
  --   lazy=false,
  --   name = "rose-pine",
  --   init = function()
  --     -- TODO: set colorscheme based on system/terminal dark/light mode
  --     -- Also see utils/colorscheme.lua
  --     vim.cmd.colorscheme("rose-pine")
  --   end,
  -- },
  -- {
  --    "nyoom-engineering/oxocarbon.nvim",
  --    lazy=false,
  --    init = function()
  --      vim.cmd.colorscheme("oxocarbon")
  --    end,
  --  },
  -- {
  --   'craftzdog/solarized-osaka.nvim',
  --   lazy = true,
  --   priority = 1000,
  --   opts = function()
  --     return {
  --       transparent = true,
  --     }
  --   end,
  --   init = function()
  --     vim.cmd.colorscheme 'solarized-osaka'
  --   end,
  -- },
  -- {
  --   'folke/twilight.nvim',
  --   opts = {
  --     dimming = {
  --       alpha = 0.5, -- amount of dimming
  --       -- we try to get the foreground from the highlight groups or fallback color
  --       color = { 'Normal', '#ffffff' },
  --       term_bg = '#000000', -- if guibg=NONE, this will be used to calculate text color
  --       inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
  --     },
  --     context = 10, -- amount of lines we will try to show around the current line
  --     treesitter = true, -- use treesitter when available for the filetype
  --     -- treesitter is used to automatically expand the visible text,
  --     -- but you can further control the types of nodes that should always be fully expanded
  --     expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
  --       'function',
  --       'method',
  --       'table',
  --       'if_statement',
  --     },
  --     exclude = {}, -- exclude these filetypes
  --     -- your configuration comes here
  --     -- or leave it empty to use the default settings
  --     -- refer to the configuration section below
  --   },
  -- },
  { 'RRethy/vim-illuminate' },
}
