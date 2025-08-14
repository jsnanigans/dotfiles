-- Editor enhancement plugins
-- Updated for snacks.nvim migration

return {
  -- Fast navigation with flash - MIGRATED TO SNACKS.JUMP
  -- {
  --   "folke/flash.nvim",
  --   event = { "BufReadPost", "BufNewFile" },
  --   opts = {},
  -- },

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

  -- Surround operations with mini.surround
  {
    "echasnovski/mini.surround",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },

  -- Better text objects with mini.ai
  {
    "echasnovski/mini.ai",
    version = false,
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
  },

  -- Split/join arguments with mini.splitjoin
  {
    "echasnovski/mini.splitjoin",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        toggle = "gS",
        split = "",
        join = "",
      },
    },
  },

  -- Align text with mini.align
  {
    "echasnovski/mini.align",
    version = false,
    event = "VeryLazy",
    opts = {},
  },

  -- Move lines/selections with mini.move
  {
    "echasnovski/mini.move",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        -- Move visual selection in Visual mode with Alt+hjkl
        left = "<M-h>",
        right = "<M-l>",
        down = "<M-j>",
        up = "<M-k>",

        -- Move current line in Normal mode with Alt+hjkl
        line_left = "<M-h>",
        line_right = "<M-l>",
        line_down = "<M-j>",
        line_up = "<M-k>",
      },
    },
  },

  -- Better f/t motions with mini.jump2d
  {
    "echasnovski/mini.jump2d",
    version = false,
    event = "VeryLazy",
    opts = {
      view = {
        dim = true,
        n_steps_ahead = 2,
      },
      mappings = {
        start_jumping = "<CR>",
      },
      silent = true,
    },
  },

  -- Highlight patterns with mini.hipatterns
  {
    "echasnovski/mini.hipatterns",
    version = false,
    event = "VeryLazy",
    opts = function()
      local hi = require("mini.hipatterns")
      return {
        highlighters = {
          -- Highlight hex colors
          hex_color = hi.gen_highlighter.hex_color(),
          -- Highlight TODO, FIXME, etc.
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        },
      }
    end,
  },

  -- Miscellaneous functions with mini.misc
  {
    "echasnovski/mini.misc",
    version = false,
    lazy = false,
    config = function()
      require("mini.misc").setup({
        make_global = { "put", "put_text" },
      })
    end,
  },

  -- Enhanced snacks.nvim with full migration features
  { import = "config.plugins.editor.snacks-full" },
}
