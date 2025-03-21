return {
  -- {
  --     "supermaven-inc/supermaven-nvim",
  --     event = "InsertEnter",
  --     config = function()
  --         require("supermaven-nvim").setup({
  --             -- log_level = "info", -- set to "off" to disable logging completely
  --             -- disable_inline_completion = true, -- disables inline completion for use with cmp
  --             disable_keymaps = true, -- disables built in keymaps for more manual control
  --         })
  --
  --         local suggestion = require("supermaven-nvim.completion_preview")
  --         vim.keymap.set("i", "<C-l>", function()
  --             suggestion.on_accept_suggestion()
  --         end)
  --     end,
  -- },
  --
  --
  -- {
  --   "milanglacier/minuet-ai.nvim",
  --   lazy = false,
  --   config = function()
  --     require("minuet").setup({
  --       provider = "gemini",
  --       provider_options = {
  --         gemini = {
  --           model = "gemini-2.0-flash",
  --           -- model = "gemini-2.0-flash-lite",
  --           -- system = "see [Prompt] section for the default value",
  --           -- few_shots = "see [Prompt] section for the default value",
  --           -- chat_input = "See [Prompt Section for default value]",
  --           stream = true,
  --           -- api_key = "GEMINI_API_KEY",
  --           -- optional = {},
  --         },
  --       },
  --
  --       -- Your configuration options here
  --       virtualtext = {
  --         auto_trigger_ft = {
  --           "*",
  --         },
  --         keymap = {
  --           -- accept whole completion
  --           accept = "<C-l>",
  --           -- accept one line
  --           accept_line = "<C-;>",
  --           -- accept n lines (prompts for number)
  --           -- e.g. "A-z 2 CR" will accept 2 lines
  --           -- accept_n_lines = "<A-z>",
  --           -- Cycle to prev completion item, or manually invoke completion
  --           prev = "<C-,>",
  --           -- Cycle to next completion item, or manually invoke completion
  --           next = "<C-.>",
  --           dismiss = "<C-k>",
  --         },
  --       },
  --     })
  --   end,
  -- },
  -- { "nvim-lua/plenary.nvim" },
  -- optional, if you are using virtual-text frontend, nvim-cmp is not
  -- required.
  -- { "hrsh7th/nvim-cmp" },
  -- optional, if you are using virtual-text frontend, blink is not required.
  -- { "Saghen/blink.cmp" },
  --
  --
  --
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      local copilot = require("copilot")
      local suggest = require("copilot.suggestion")
      copilot.setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
        },
        filetypes = {
          ["*"] = true,
        },
      })

      -- vim.keymap.set("n", "<C-x>", function()
      --   suggest.toggle_auto_trigger()
      -- end)

      vim.keymap.set("i", "<C-l>", function()
        suggest.accept()
      end)
      -- vim.keymap.set('i', '<C-x>', function()
      --   suggest.prev()
      -- end)
      -- vim.keymap.set('i', '<C-c>', function()
      --   suggest.next()
      -- end)
      vim.keymap.set("i", "<C-z>", function()
        suggest.dismiss()
      end)
      vim.keymap.set("i", "<C-;>", function()
        suggest.accept_word()
      end)
    end,
  },
  --
  --
  --
  -- {
  --   "olimorris/codecompanion.nvim",
  --   lazy = false,
  --   dependencies = {},
  --   opts = {
  --     --Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
  --     strategies = {
  --       --NOTE: Change the adapter as required
  --       chat = { adapter = "copilot" },
  --       inline = { adapter = "copilot" },
  --     },
  --     opts = {
  --       log_level = "DEBUG",
  --     },
  --   },
  -- },
  --
  --
  --
  --
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
      { "nvim-lua/plenary.nvim" },
      -- { "echasnovski/mini.diff" },
      -- { "sindrets/diffview.nvim" },
    },
    lazy = false,
    config = function()
      require("codecompanion").setup({
        display = {
          diff = {
            -- provider = "diffview-merge-tool",
          },
        },
        strategies = {
          chat = {
            -- adapter = "gemini",
            adapter = "copilot",
          },
          inline = {
            -- adapter = "gemini",
            adapter = "copilot",
          },
          agent = {
            -- adapter = "gemini",
            adapter = "copilot",
          },
        },
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-3.7-sonnet",
                },
              },
            })
          end,
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              url = "https://generativelanguage.googleapis.com/v1beta/models/${model}:streamGenerateContent?alt=sse&key=${api_key}",
              env = {
                api_key = "AIzaSyAslnhPbB7YG2LPKf-q61okM91AWl45SoU",
                model = "gemini-2.0-flash-thinking-exp-01-20",
              },
            })
          end,
          -- anthropic = function()
          --   return require("codecompanion.adapters").extend("anthropic", {
          --     env = {
          --       api_key = vim.env.TOKEN_ANTHROPIC,
          --     },
          --   })
          -- end,
          -- openai = function()
          --   return require("codecompanion.adapters").extend("openai", {
          --     env = {
          --       api_key = vim.env.TOKEN_OPENAI,
          --     },
          --   })
          -- end,
        },
      })
    end,
  },
  --
  --
  --
  --
  -- {
  --   "huggingface/llm.nvim",
  --   lazy=false,
  --   config = function ()
  --     require('llm').setup({
  --       model = "bigcode/starcoder",
  --       url = "http://localhost:8080", -- llm-ls uses "/generate"
  --       -- cf https://huggingface.github.io/text-generation-inference/#/Text%20Generation%20Inference/generate
  --       request_body = {
  --         parameters = {
  --           temperature = 0.2,
  --           top_p = 0.95,
  --         }
  --       }
  --     })
  --   end
  -- },
  --   model = "codellama:7b",
  --   url = "http://localhost:11434", -- llm-ls uses "/api/generate"
  --   -- cf https://github.com/ollama/ollama/blob/main/docs/api.md#parameters
  --   request_body = {
  --     -- Modelfile options for the model you use
  --     options = {
  --       temperature = 0.2,
  --       top_p = 0.95,
  --     },
  --   },
  -- }),
  -- {
  --   "yetone/avante.nvim",
  --   -- disabled = true,
  --   event = "VeryLazy",
  --   lazy = false,
  --   version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  --   opts = {
  --     ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  --     provider = "gemini",
  --     gemini = {
  --       model = "gemini-2.0-flash-lite-preview-02-05"
  --     },
  --     behaviour = {
  --       auto_suggestions = false, -- Experimental stage
  --       auto_set_highlight_group = true,
  --       auto_set_keymaps = true,
  --       auto_apply_diff_after_generation = false,
  --       support_paste_from_clipboard = false,
  --       minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
  --       enable_token_counting = true, -- Whether to enable token counting. Default to true.
  --     },
  --     mappings={
  --
  --         suggestion = {
  --         accept = "<M-l>",
  --         next = "<M-]>",
  --         prev = "<M-[>",
  --         dismiss = "<C-]>",
  --       },
  --     }
  --     -- openai = {
  --       -- endpoint = "https://api.openai.com/v1",
  --       -- model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
  --       -- timeout = 30000, -- timeout in milliseconds
  --       -- temperature = 0, -- adjust if needed
  --       -- max_tokens = 4096,
  --     -- },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "echasnovski/mini.pick", -- for file_selector provider mini.pick
  --     "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --     "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     "zbirenbaum/copilot.lua", -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- },
}
