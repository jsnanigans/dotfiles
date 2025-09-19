-- UI enhancement plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files
-- Migrated to use MARVIM framework for better error handling and consistency

local M = require("marvim.plugin_helper")

return {
  -- Flexoki theme
  {
    "kepano/flexoki-neovim",
    name = "flexoki",
    lazy = false,
    priority = 1000,
    config = function()
      -- Load colorscheme
      vim.cmd.colorscheme("flexoki-dark")

      -- Apply custom theme utilities
      vim.schedule(function()
        local theme = M.safe_require("utils.theme")
        if theme and theme.setup then
          theme.setup()
        end
      end)
    end,
  },

  -- Complex plugins kept in separate files
  { import = "config.plugins.ui.statusline" },
  { import = "config.plugins.ui.notifications" },
  { import = "config.plugins.ui.indentation" },
  { import = "config.plugins.ui.breadcrumbs" },
}
