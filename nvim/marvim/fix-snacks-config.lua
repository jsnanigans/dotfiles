-- Fix script for snacks.nvim configuration
-- This file contains the corrected configuration based on actual available modules

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Picker configuration (exists and works)
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
      },

      -- Input UI (exists and works)
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

      -- Notifications (exists and works)
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

      -- LazyGit integration (exists and works)
      lazygit = {
        enabled = true,
        win = {
          width = 0.9,
          height = 0.9,
          border = "rounded",
        },
      },

      -- Scope indication (exists and works)
      scope = {
        enabled = true,
        cursor = true,
        textobjects = true,
        treesitter = true,
      },

      -- Dashboard (optional)
      dashboard = {
        enabled = false,
      },

      -- Statuscolumn (optional)
      statuscolumn = {
        enabled = false,
      },

      -- Toggle utilities (exists and works)
      toggle = {
        enabled = true,
        map = {
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

      -- Other available modules (not configured yet):
      -- bigfile = { enabled = false },
      -- bufdelete = { enabled = false },
      -- debug = { enabled = false },
      -- dim = { enabled = false },
      -- git = { enabled = false },
      -- gitbrowse = { enabled = false },
      -- indent = { enabled = false },
      -- quickfile = { enabled = false },
      -- rename = { enabled = false },
      -- scratch = { enabled = false },
      -- scroll = { enabled = false },
      -- terminal = { enabled = false },
      -- win = { enabled = false },
      -- words = { enabled = false },
      -- zen = { enabled = false },
    },
    keys = function()
      return {
        -- NOTE: Session management uses persistence.nvim (snacks doesn't have session module)

        -- Notifications
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

        -- Git UI (lazygit module)
        {
          "<leader>gg",
          function()
            require("snacks").lazygit()
          end,
          desc = "LazyGit",
        },
        {
          "<leader>gG",
          function()
            require("snacks").lazygit({ cwd = vim.uv.cwd() })
          end,
          desc = "LazyGit (cwd)",
        },
        {
          "<leader>gf",
          function()
            require("snacks").lazygit.log_file()
          end,
          desc = "LazyGit File History",
        },
        {
          "<leader>gl",
          function()
            require("snacks").lazygit.log()
          end,
          desc = "LazyGit Log",
        },

        -- NOTE: Navigation uses flash.nvim (snacks doesn't have jump module)

        -- TODO Comments (using picker)
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
            vim.fn.search("\\(TODO\\|HACK\\|PERF\\|NOTE\\|FIX\\|FIXME\\|WARNING\\):", "")
          end,
          desc = "Next TODO",
        },
        {
          "[t",
          function()
            vim.fn.search("\\(TODO\\|HACK\\|PERF\\|NOTE\\|FIX\\|FIXME\\|WARNING\\):", "b")
          end,
          desc = "Previous TODO",
        },
      }
    end,
    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)

      -- Set up vim.ui.select to use snacks picker
      vim.ui.select = function(items, opts_param, on_choice)
        require("snacks").picker.select(items, opts_param, on_choice)
      end

      -- Set up vim.notify to use snacks notifier
      vim.notify = function(msg, level, opts_param)
        require("snacks").notifier.notify(msg, level, opts_param)
      end

      -- Create user commands for backward compatibility with lazygit.nvim
      vim.api.nvim_create_user_command("LazyGit", function()
        snacks.lazygit()
      end, { desc = "Open LazyGit (snacks.nvim)" })

      vim.api.nvim_create_user_command("LazyGitFile", function()
        snacks.lazygit.log_file()
      end, { desc = "Open LazyGit for current file" })

      vim.api.nvim_create_user_command("LazyGitLog", function()
        snacks.lazygit.log()
      end, { desc = "Open LazyGit log" })
    end,
  },
}
