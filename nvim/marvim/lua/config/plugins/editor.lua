-- Editor enhancement plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

return {
  -- Fast navigation with flash
  {
    "folke/flash.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- commenting
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },

  -- File navigation with harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
      },
    },
  },

  -- Smart splits for tmux/window navigation
  {
    "mrjones2014/smart-splits.nvim",
    cond = function()
      return vim.g.tmux_navigation_enabled
    end,
    lazy = false,
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "prompt" },
      default_amount = 3,
      at_edge = "wrap",
      move_cursor_same_row = false,
      cursor_follows_swapped_bufs = false,
      resize_mode = {
        quit_key = "<ESC>",
        resize_keys = { "h", "j", "k", "l" },
        silent = false,
      },
      ignored_events = {
        "BufEnter",
        "WinEnter",
      },
      multiplexer_integration = "tmux",
      disable_multiplexer_nav_when_zoomed = true,
    },
    keys = function()
      return require("config.keymaps").smart_splits_keys
    end,
  },

  -- Oil file manager with simple config
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    opts = {
      columns = { "icon" },
      keymaps = {
        ["<C-h>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      view_options = {
        show_hidden = true,
      },
      default_file_explorer = true,
    },
    keys = function()
      return require("config.keymaps").oil_keys
    end,
  },



  -- Better undo management with tree visualization
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = function()
      return require("config.keymaps").undotree_keys
    end,
    opts = {
      WindowLayout = 2,
      ShortIndicators = 1,
      SetFocusWhenToggle = 1,
      TreeNodeShape = "●",
      DiffAutoOpen = 0,
    },
    config = function(_, opts)
      for key, value in pairs(opts) do
        vim.g["undotree_" .. key] = value
      end
    end,
  },

  -- Complex plugins kept in separate files
  { import = "config.plugins.editor.snacks" },
  { import = "config.plugins.editor.mini" },
}
