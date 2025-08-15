-- UI enhancement plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

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
        local ok, theme = pcall(require, "utils.theme")
        if ok then
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
