-- Git integration plugins
-- Plugins with low cognitive complexity are consolidated here, complex ones get separate files

return {
  -- LazyGit integration - MIGRATED TO SNACKS.LAZYGIT
  -- {
  --   "kdheepak/lazygit.nvim",
  --   cmd = "LazyGit",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   config = function()
  --     vim.g.lazygit_floating_window_winblend = 0
  --     vim.g.lazygit_floating_window_scaling_factor = 0.9
  --     vim.g.lazygit_floating_window_corner_chars = { "╭", "╮", "╰", "╯" }
  --     vim.g.lazygit_floating_window_use_plenary = 0
  --     vim.g.lazygit_use_neovim_remote = 1
  --   end,
  -- },

  -- Complex plugins kept in separate files
  -- Using mini.diff and mini.git instead of gitsigns and git-conflict
  { import = "config.plugins.git.mini-git" },
  { import = "config.plugins.git.diffview" },
}
