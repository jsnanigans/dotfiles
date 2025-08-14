return {
  {
    "nvim-lualine/lualine.nvim",
    event = { "UIEnter" }, -- Load when UI is ready
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
    end,
    opts = function()
      local lualine_require = require("lualine_require")
      lualine_require.require = require
      local icons = {
        diagnostics = {
          Error = " ",
          Warn = " ",
          Hint = " ",
          Info = " ",
        },
        git = {
          added = " ",
          modified = " ",
          removed = " ",
        },
      }
      vim.o.laststatus = vim.g.lualine_laststatus
      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
          },
          lualine_x = {
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = function()
                local colors = require("utils.theme").colors
                return { fg = colors.gold }
              end,
            },
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = function()
                local colors = require("utils.theme").colors
                return { fg = colors.gold }
              end,
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = function()
                local colors = require("utils.theme").colors
                return { fg = colors.gold }
              end,
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function()
                local colors = require("utils.theme").colors
                return { fg = colors.gold }
              end,
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                -- Use mini.diff summary if available
                local ok, diff = pcall(require, "mini.diff")
                if ok then
                  local summary = vim.b.minidiff_summary
                  if summary then
                    return {
                      added = summary.add,
                      modified = summary.change,
                      removed = summary.delete,
                    }
                  end
                end
                -- Fallback to git status if available
                local git_status = vim.b.git_status_dict
                if git_status then
                  return {
                    added = git_status.added,
                    modified = git_status.changed,
                    removed = git_status.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
      }
    end,
  },
}
