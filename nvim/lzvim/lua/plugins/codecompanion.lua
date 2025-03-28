return {
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" },
  --     { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  --     { "nvim-lua/plenary.nvim" },
  --     -- { "echasnovski/mini.diff" },
  --     -- { "sindrets/diffview.nvim" },
  --   },
  --   lazy = false,
  --   config = function()
  --     require("codecompanion").setup({
  --       display = {
  --         diff = {
  --           -- provider = "diffview-merge-tool",
  --         },
  --       },
  --       strategies = {
  --         chat = {
  --           -- adapter = "gemini",
  --           adapter = "copilot",
  --         },
  --         inline = {
  --           -- adapter = "gemini",
  --           adapter = "copilot",
  --         },
  --         agent = {
  --           -- adapter = "gemini",
  --           adapter = "copilot",
  --         },
  --       },
  --       adapters = {
  --         copilot = function()
  --           return require("codecompanion.adapters").extend("copilot", {
  --             schema = {
  --               model = {
  --                 default = "claude-3.7-sonnet",
  --               },
  --             },
  --           })
  --         end,
  --         gemini = function()
  --           return require("codecompanion.adapters").extend("gemini", {
  --             url = "https://generativelanguage.googleapis.com/v1beta/models/${model}:streamGenerateContent?alt=sse&key=${api_key}",
  --             env = {
  --               api_key = "AIzaSyAslnhPbB7YG2LPKf-q61okM91AWl45SoU",
  --               model = "gemini-2.0-flash-thinking-exp-01-20",
  --             },
  --           })
  --         end,
  --         -- anthropic = function()
  --         --   return require("codecompanion.adapters").extend("anthropic", {
  --         --     env = {
  --         --       api_key = vim.env.TOKEN_ANTHROPIC,
  --         --     },
  --         --   })
  --         -- end,
  --         -- openai = function()
  --         --   return require("codecompanion.adapters").extend("openai", {
  --         --     env = {
  --         --       api_key = vim.env.TOKEN_OPENAI,
  --         --     },
  --         --   })
  --         -- end,
  --       },
  --     })
  --   end,
  -- },
}
