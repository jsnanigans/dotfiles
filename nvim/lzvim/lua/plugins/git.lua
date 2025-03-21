return {
  {
    "echasnovski/mini.diff",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    version = false,
    config = function()
      require("mini.diff").setup({
        -- options = {
        --   source = "saved", -- 'saved', 'last_commit', 'staged', a function, etc.
        -- },
        -- source = {
        --   -- Use 'git' as the source for diff data
        --   git = {
        --     -- Command used for git diff
        --     command = "git",
        --     -- Arguments for git diff
        --     args = { "diff", "--color=never", "--no-ext-diff", "--no-index" },
        --     -- Path to target file (empty means current file)
        --     target_path = "",
        --   },
        --
        --   -- Fall back to manual source if git doesn't work
        --   fallback = "manual",
        -- },
        --
        -- -- Configure other options as needed
        -- window = {
        --   delay = 100, -- Refresh delay in ms
        --   width = 40, -- Width of the window
        -- },
        --
        -- -- Options for symbols and highlight groups
        -- symbols = {
        --   -- Line symbols
        --   add = "+", -- Added line
        --   change = "~", -- Changed line
        --   delete = "_", -- Deleted line
        -- },
      })
    end,
  },

  -- {
  --     "lewis6991/gitsigns.nvim",
  --     event = "BufRead",
  --     lazy = false,
  --     config = function()
  --         require("gitsigns").setup()
  --     end,
  -- }
}
