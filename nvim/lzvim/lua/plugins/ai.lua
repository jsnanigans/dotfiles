return {
    {
        "supermaven-inc/supermaven-nvim",
        event = "InsertEnter",
        config = function()
            require("supermaven-nvim").setup({
                -- log_level = "info", -- set to "off" to disable logging completely
                -- disable_inline_comletion = true, -- disables inline completion for use with cmp
                disable_keymaps = true, -- disables built in keymaps for more manual control
            })

            local suggestion = require("supermaven-nvim.completion_preview")
            vim.keymap.set("i", "<C-l>", function()
                suggestion.on_accept_suggestion()
            end)
        end,
    },
    -- {
    --   "zbirenbaum/copilot.lua",
    --   cmd = "Copilot",
    --   event = "InsertEnter",
    --   config = function()
    --     local copilot = require("copilot")
    --     local suggest = require("copilot.suggestion")
    --     copilot.setup({
    --       suggestion = {
    --         enabled = true,
    --         auto_trigger = true,
    --       },
    --     })
    --
    --     vim.keymap.set("n", "<C-x>", function()
    --       -- suggest.toggle_auto_trigger()
    --     end)
    --     vim.keymap.set("i", "<C-s>", function()
    --       suggest.accept()
    --     end)
    --     -- vim.keymap.set('i', '<C-x>', function()
    --     --   suggest.prev()
    --     -- end)
    --     -- vim.keymap.set('i', '<C-c>', function()
    --     --   suggest.next()
    --     -- end)
    --     vim.keymap.set("i", "<C-z>", function()
    --       suggest.dismiss()
    --     end)
    --     vim.keymap.set("i", "<C-l>", function()
    --       suggest.accept_word()
    --     end)
    --   end,
    -- },
    -- {
    --   "olimorris/codecompanion.nvim",
    --   dependencies = {
    --     "github/copilot.vim",
    --     "sindrets/diffview.nvim",
    --     "nvim-lua/plenary.nvim",
    --     "nvim-treesitter/nvim-treesitter",
    --     "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    --     "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    --     { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
    --   },
    --   config = function()
    --     require("codecompanion").setup({
    --       strategies = {
    --         chat = {
    --           adapter = "anthropic",
    --         },
    --         inline = {
    --           adapter = "copilot",
    --         },
    --         agent = {
    --           adapter = "anthropic",
    --         },
    --       },
    --       adapters = {
    --         anthropic = function()
    --           return require("codecompanion.adapters").extend("anthropic", {
    --             env = {
    --               api_key = vim.env.TOKEN_ANTHROPIC,
    --             },
    --           })
    --         end,
    --         openai = function()
    --           return require("codecompanion.adapters").extend("openai", {
    --             env = {
    --               api_key = vim.env.TOKEN_OPENAI,
    --             },
    --           })
    --         end,
    --       },
    --     })
    --   end,
    -- },
}
