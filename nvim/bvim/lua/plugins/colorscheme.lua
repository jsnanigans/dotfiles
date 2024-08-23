return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'auto', -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = 'dark',
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { 'italic' }, -- Change the style of comments
          conditionals = { 'italic' },
          loops = {},
          functions = { 'bold' },
          keywords = {
            'italic',
          },
          strings = {},
          variables = { 'bold' },
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      }

      -- setup must be called before loading
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  -- {
  --   'folke/tokyonight.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   -- opts = {
  --   -- },
  --   -- init = function()
  --   --   -- TODO: set colorscheme based on system/terminal dark/light mode
  --   --   -- Also see utils/colorscheme.lua
  --   -- end,
  --   config = function()
  --     require('tokyonight').setup {
  --       -- transparent = true,
  --       styles = {
  --         comments = { italic = true },
  --         keywords = {
  --           italic = true,
  --         },
  --         functions = {
  --           bold = true,
  --         },
  --         variables = {
  --           bold = true,
  --         },
  --       },
  --       -- style = 'night',
  --     }
  --     vim.cmd.colorscheme 'tokyonight'
  --   end,
  -- },
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
