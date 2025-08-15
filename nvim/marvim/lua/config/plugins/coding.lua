-- Coding enhancement plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

return {
  -- Diagnostics with Trouble v3 configuration
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      -- Ensure diagnostic signs are set up before Trouble loads
      local icons = require("config.icons")
      icons.setup_diagnostic_signs()
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
        kinds = require("config.icons").kinds,
      },
    },
    keys = function()
      return require("config.keymaps").trouble_keys
    end,
  },

  -- Todo comments with minimal config
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = true,
    keys = function()
      return require("config.keymaps").todo_comments_keys
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
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = function()
      return require("config.keymaps").luasnip_keys
    end,
  },

  -- Complex plugins kept in separate files
  { import = "config.plugins.coding.treesitter" },
  { import = "config.plugins.coding.conform" },
}
