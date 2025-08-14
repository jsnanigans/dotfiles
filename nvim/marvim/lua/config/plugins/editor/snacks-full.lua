return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Existing picker config (enhanced)
      picker = {
        enabled = true,
        sources = {
          grep = {
            cmd = "rg",
            args = {
              "--column",
              "--line-number",
              "--no-heading",
              "--color=never",
              "--smart-case",
              "--with-filename",
            },
          },
          files = {
            cmd = "fd",
            args = {
              "--type=file",
              "--hidden",
              "--exclude",
              "node_modules",
              "--exclude",
              ".git",
              "--exclude",
              "dist",
              "--exclude",
              "build",
              "--exclude",
              ".next",
              "--exclude",
              "coverage",
              "--exclude",
              "__pycache__",
              "--exclude",
              ".pytest_cache",
              "--exclude",
              ".DS_Store",
            },
          },
        },
        layout = {
          preset = "ivy",
        },
        icons = {
          enabled = true,
        },
        ui = {
          select = true,
        },
        win = {
          input = {
            keys = {
              ["<C-c>"] = { "close", mode = { "n", "i" } },
              ["<C-j>"] = { "move_down", mode = { "i", "n" } },
              ["<C-k>"] = { "move_up", mode = { "i", "n" } },
            },
          },
          list = {
            cursorline = true,
          },
        },
        presets = {
          todos = {
            prompt_title = "Todo Comments",
            finder = "grep",
            pattern = "TODO|HACK|PERF|NOTE|FIX|FIXME|WARNING",
            flags = "--case-sensitive",
          },
        },
      },

      -- Session management (replaces persistence.nvim)
      session = {
        enabled = true,
        autoload = false, -- Don't autoload on startup
        autosave = true,
        options = { "buffers", "curdir", "globals", "help", "tabpages", "winsize" },
      },

      -- Input UI (replaces dressing.nvim for vim.ui.input)
      input = {
        enabled = true,
        win = {
          relative = "cursor",
          row = 1,
          col = 0,
          width = 60,
          height = 1,
          border = "rounded",
        },
      },

      -- Notifications (replaces noice.nvim notifications)
      notifier = {
        enabled = true,
        timeout = 3000,
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true,
        sort = { "added" },
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          debug = " ",
          trace = " ",
        },
        style = "compact",
      },

      -- LazyGit integration (replaces lazygit.nvim)
      lazygit = {
        enabled = true,
        win = {
          width = 0.9,
          height = 0.9,
          border = "rounded",
        },
      },

      -- Scope indication (part of flash replacement)
      scope = {
        enabled = true,
        cursor = true,
        textobjects = true,
        treesitter = true,
      },

      -- Jump navigation (replaces flash.nvim)
      jump = {
        enabled = true,
        mode = "default",
        reverse = false,
        wrap = true,
        multi_windows = false,
        keys = {
          next = ";",
          prev = ",",
        },
      },

      -- Dashboard (optional, but nice to have)
      dashboard = {
        enabled = false, -- Enable if you want a dashboard
      },

      -- Statuscolumn (potential dropbar alternative for simple cases)
      statuscolumn = {
        enabled = false, -- Keep false for now, dropbar is more feature-rich
      },

      -- Toggle utilities (partial which-key replacement for toggles)
      toggle = {
        enabled = true,
        map = {
          -- Common toggles
          diagnostics = {
            key = "<leader>ud",
            name = "Diagnostics",
          },
          wrap = {
            key = "<leader>uw",
            name = "Wrap",
          },
          spell = {
            key = "<leader>us",
            name = "Spell",
          },
          number = {
            key = "<leader>un",
            name = "Line Numbers",
          },
          relativenumber = {
            key = "<leader>ur",
            name = "Relative Numbers",
          },
          conceallevel = {
            key = "<leader>uc",
            name = "Conceal Level",
          },
        },
      },
    },
    keys = function()
      return {
        -- Session management (replaces persistence)
        {
          "<leader>qs",
          function()
            require("snacks").session.load()
          end,
          desc = "Load Session",
        },
        {
          "<leader>ql",
          function()
            require("snacks").session.load({ last = true })
          end,
          desc = "Load Last Session",
        },
        {
          "<leader>qd",
          function()
            require("snacks").session.stop()
          end,
          desc = "Stop Session",
        },
        {
          "<leader>qS",
          function()
            require("snacks").session.save()
          end,
          desc = "Save Session",
        },

        -- Notifications (replaces noice)
        {
          "<leader>sn",
          function()
            require("snacks").notifier.show()
          end,
          desc = "Show Notifications",
        },
        {
          "<leader>snh",
          function()
            require("snacks").notifier.history()
          end,
          desc = "Notification History",
        },
        {
          "<leader>snc",
          function()
            require("snacks").notifier.clear()
          end,
          desc = "Clear Notifications",
        },

        -- Git UI (replaces lazygit)
        {
          "<leader>gg",
          function()
            require("snacks").lazygit.open()
          end,
          desc = "LazyGit",
        },
        {
          "<leader>gf",
          function()
            require("snacks").lazygit.file()
          end,
          desc = "LazyGit File",
        },
        {
          "<leader>gl",
          function()
            require("snacks").lazygit.log()
          end,
          desc = "LazyGit Log",
        },

        -- Navigation (replaces flash)
        {
          "s",
          mode = { "n", "x", "o" },
          function()
            require("snacks").jump.jump()
          end,
          desc = "Jump",
        },
        {
          "S",
          mode = { "n", "x", "o" },
          function()
            require("snacks").jump.jump({ treesitter = true })
          end,
          desc = "Jump Treesitter",
        },

        -- TODO Comments (using picker patterns)
        {
          "<leader>st",
          function()
            require("snacks").picker.grep({ pattern = "TODO|HACK|PERF|NOTE|FIX|FIXME|WARNING" })
          end,
          desc = "Search TODOs",
        },
        {
          "<leader>sT",
          function()
            require("snacks").picker.grep({ pattern = "TODO|FIX|FIXME" })
          end,
          desc = "Search FIXMEs",
        },
        {
          "]t",
          function()
            -- Navigate to next TODO
            vim.fn.search("\\(TODO\\|HACK\\|PERF\\|NOTE\\|FIX\\|FIXME\\|WARNING\\):", "")
          end,
          desc = "Next TODO",
        },
        {
          "[t",
          function()
            -- Navigate to previous TODO
            vim.fn.search("\\(TODO\\|HACK\\|PERF\\|NOTE\\|FIX\\|FIXME\\|WARNING\\):", "b")
          end,
          desc = "Previous TODO",
        },
      }
    end,
    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)

      -- Set up vim.ui.select to use snacks
      vim.ui.select = function(items, opts_param, on_choice)
        require("snacks").picker.select(items, opts_param, on_choice)
      end

      -- Optional: Set up vim.notify to use snacks
      vim.notify = function(msg, level, opts_param)
        require("snacks").notifier.notify(msg, level, opts_param)
      end
    end,
  },
}
