-- TS-comments.nvim - Treesitter-aware commenting
return {
  "folke/ts-comments.nvim",
  opts = {},
  keys = {
    { "gcc", mode = "n", desc = "Toggle comment line" },
    { "gc", mode = { "n", "v" }, desc = "Toggle comment" },
    { "gbc", mode = "n", desc = "Toggle block comment line" },
    { "gb", mode = { "n", "v" }, desc = "Toggle block comment" },
  },
  event = "VeryLazy",
  enabled = vim.fn.has("nvim-0.10.0") == 1,
} 