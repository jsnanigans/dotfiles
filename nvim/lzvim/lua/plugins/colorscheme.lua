return {
  -- { 'Mofiqul/dracula.nvim', lazy = false, priority = 1000 },
  {
    "catppuccin/nvim",
    lazy = false,
    enable = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto", -- latte, frappe, macchiato, mocha
        -- background = { -- :h background
        --   light = "latte",
        --   dark = "mocha",
        -- },
        -- transparent_background = false, -- disables setting the background color.
        -- show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        -- term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        -- dim_inactive = {
        --   enabled = false, -- dims the background color of inactive window
        --   shade = "dark",
        --   percentage = 0.15, -- percentage of the shade to apply to the inactive window
        -- },
        color_overrides = {
          mocha = {
            base = "#000000",
            mantle = "#000000",
            crust = "#000000",
          },
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    enable = false,
    priority = 1000,
  },
  {
    "Mofiqul/vscode.nvim",
    enable = false,
    lazy = false,
    priority = 1000,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    enable = false,
    priority = 1000,
  },
  {
    "tokyonight.nvim",
    lazy = false,
    -- enable = false,
    priority = 1000,
    opts = function()
      return {
        -- style = "day",
        -- light_style = "moon",
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        on_highlights = function(hl, c)
          -- hl.Normal = "Foo"
          do
            return
          end
          local prompt = "#2d3149"
          -- hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg }
          -- hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
          -- hl.TelescopePromptNormal = { bg = prompt }
          -- hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
          -- hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
          -- hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
          -- hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
        end,
      }
    end,
  },
}
