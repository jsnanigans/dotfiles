-- Editor enhancement plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

return {
  -- Fast navigation with flash
  {
    "folke/flash.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- commenting with mini.comment
  {
    "echasnovski/mini.comment",
    version = false,
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },

  -- File navigation with mini.visits
  {
    "echasnovski/mini.visits",
    version = false,
    event = "VeryLazy",
    opts = {
      -- Track visited files
      track = {
        event = "BufEnter",
        delay = 1000,
      },
      -- Store visits data
      store = {
        path = vim.fn.stdpath("data") .. "/mini-visits.lua",
        autowrite = true,
      },
    },
    config = function(_, opts)
      require("mini.visits").setup(opts)
      -- Create labels for quick access (similar to harpoon)
      local MiniVisits = require("mini.visits")
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniVisitsModule",
        callback = function()
          -- Create a label for pinned files (like harpoon)
          MiniVisits.add_label("pinned", { sort = MiniVisits.gen_sort.default() })
        end,
      })
    end,
  },

  -- Auto pairs with mini.pairs
  {
    "echasnovski/mini.pairs",
    version = false,
    event = "InsertEnter",
    opts = {
      modes = { insert = true, command = false, terminal = false },
      -- Skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- Skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- Skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- Better mapping for completion acceptance
      mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
      },
    },
    config = function(_, opts)
      require("mini.pairs").setup(opts)
      -- Integration with completion (if using blink.cmp or nvim-cmp)
      local ok_cmp, cmp = pcall(require, "blink.cmp")
      if ok_cmp then
        -- For blink.cmp
        vim.keymap.set("i", "<CR>", function()
          if cmp.is_visible() then
            return cmp.accept()
          else
            return require("mini.pairs").cr()
          end
        end, { expr = true })
      end
    end,
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
