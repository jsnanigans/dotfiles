return {
  {
    "yetone/avante.nvim",
    -- disabled = true,
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      -- provider = "copilot",
      provider = "gemini",
      gemini = {
        -- model = "gemini-2.0-flash",
        model = "gemini-2.5-pro-exp-03-25",
      },
      behaviour = {
        -- enable_cursor_planning_mode = true, -- enable cursor planning mode!
        auto_suggestions = true, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        support_paste_from_clipboard = true,
        minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
        enable_token_counting = true, -- Whether to enable token counting. Default to true.
      },
      mappings = {

        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      -- openai = {
      -- endpoint = "https://api.openai.com/v1",
      -- model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
      -- timeout = 30000, -- timeout in milliseconds
      -- temperature = 0, -- adjust if needed
      -- max_tokens = 4096,
      -- },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
