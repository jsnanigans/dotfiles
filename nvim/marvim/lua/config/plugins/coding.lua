-- Coding enhancement plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files
-- Migrated to use MARVIM framework for better error handling and consistency

local M = require("marvim.plugin_helper")

return {
  -- Diagnostics with Trouble v3 configuration
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      -- Ensure diagnostic signs are set up before Trouble loads
      local icons = M.safe_require("config.icons")
      if icons and icons.setup_diagnostic_signs then
        icons.setup_diagnostic_signs()
      end
    end,
    opts = {
      auto_close = false,
      auto_fold = false,
      auto_jump = false,
      auto_open = false,
      auto_preview = true,
      focus = true,
      follow = true,
      indent_guides = true,
      multiline = true,
      pinned = false,
      warn_no_results = true,
      open_no_results = false,
      win = {
        size = { width = 0.3, height = 0.3 },
        padding = { top = 1, left = 1 },
      },
      preview = {
        type = "main",
        scratch = true,
      },
      throttle = {
        refresh = 20,
        update = 10,
        render = 10,
        follow = 100,
        preview = { ms = 100, debounce = true },
      },
      keys = {
        ["?"] = "help",
        r = "refresh",
        R = "toggle_refresh",
        q = "close",
        o = "jump_close",
        ["<esc>"] = "cancel",
        ["<cr>"] = "jump",
        ["<2-leftmouse>"] = "jump",
        ["<c-s>"] = "jump_split",
        ["<c-v>"] = "jump_vsplit",
        ["<c-t>"] = "jump_tab",
        j = "next",
        k = "prev",
        dd = "delete",
        d = { action = "delete", mode = "v" },
        i = "inspect",
        p = "preview",
        P = "toggle_preview",
        zo = "fold_open",
        zO = "fold_open_recursive",
        zc = "fold_close",
        zC = "fold_close_recursive",
        za = "fold_toggle",
        zA = "fold_toggle_recursive",
        zm = "fold_more",
        zM = "fold_close_all",
        zr = "fold_reduce",
        zR = "fold_open_all",
        zx = "fold_update",
        zX = "fold_update_all",
        zn = "fold_disable",
        zN = "fold_enable",
        zi = "fold_toggle_enable",
        gb = {
          action = function(view)
            view:filter({ buf = 0 }, { toggle = true })
          end,
          desc = "Toggle Current Buffer Filter",
        },
        s = {
          action = function(view)
            local f = view:get_filter("severity")
            local severity = ((f and f.filter.severity or 0) + 1) % 5
            view:filter({ severity = severity }, {
              id = "severity",
              template = "{hl:Title}Filter:{hl} {severity}",
              del = severity == 0,
            })
          end,
          desc = "Toggle Severity Filter",
        },
      },
      icons = {
        indent = {
          top = "│ ",
          middle = "├╴",
          last = "└╴",
          fold_open = " ",
          fold_closed = " ",
          ws = "  ",
        },
        folder_closed = " ",
        folder_open = " ",
        kinds = (function()
          local icons = M.safe_require("config.icons")
          return icons and icons.kinds or {}
        end)(),
      },
    },
    keys = function()
      local keymaps = M.safe_require("config.keymaps")
      return keymaps and keymaps.trouble_keys or {}
    end,
  },

  -- Todo comments with minimal config
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = true,
    keys = function()
      local keymaps = M.safe_require("config.keymaps")
      return keymaps and keymaps.todo_comments_keys or {}
    end,
  },

  -- Snippets with simple build function
  {
    "L3MON4D3/LuaSnip",
    build = (function()
      if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
        return
      end
      return "make install_jsregexp"
    end)(),
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          local loader = M.safe_require("luasnip.loaders.from_vscode")
          if loader and loader.lazy_load then
            loader.lazy_load()
          end
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = function()
      local keymaps = M.safe_require("config.keymaps")
      return keymaps and keymaps.luasnip_keys or {}
    end,
  },

  -- Complex plugins kept in separate files
  { import = "config.plugins.coding.treesitter" },
  { import = "config.plugins.coding.conform" },
}
