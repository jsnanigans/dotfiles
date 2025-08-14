return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "marilari88/neotest-vitest",
    },
    event = { "BufReadPost", "BufNewFile" },
    keys = function()
      return require("config.keymaps").neotest_keys
    end,
    opts = function()
      return {
        adapters = {
          require("neotest-vitest")({
            vitestCommand = "npx vitest run",
            env = {
              CI = true,
              VITEST_REPORTER = "verbose",
            },
            -- Additional TypeScript/Vitest specific settings
            is_test_file = function(file_path)
              local patterns = {
                "%.test%.ts$",
                "%.test%.tsx$",
                "%.spec%.ts$",
                "%.spec%.tsx$",
                "%.test%.js$",
                "%.test%.jsx$",
                "%.spec%.js$",
                "%.spec%.jsx$",
              }
              for _, pattern in ipairs(patterns) do
                if file_path:match(pattern) then
                  return true
                end
              end
              return false
            end,
          }),
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = true,
        },
        output = {
          enabled = true,
          open_on_run = "short",
        },
        quickfix = {
          enabled = false,
        },
        summary = {
          enabled = true,
          animated = true,
          follow = true,
          expand_errors = true,
          mappings = {
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            output = "o",
            short = "O",
            attach = "a",
            jumpto = "i",
            stop = "u",
            run = "r",
            debug = "d",
            mark = "m",
            run_marked = "R",
            debug_marked = "D",
            clear_marked = "M",
            target = "t",
            clear_target = "T",
            next_failed = "J",
            prev_failed = "K",
          },
        },
        icons = {
          child_indent = "│",
          child_prefix = "├",
          collapsed = "─",
          expanded = "╮",
          failed = "✖",
          final_child_indent = " ",
          final_child_prefix = "╰",
          non_collapsible = "─",
          passed = "✔",
          running = "●",
          running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
          skipped = "○",
          unknown = "?",
          watching = "👁",
        },
        floating = {
          border = "rounded",
          max_height = 0.6,
          max_width = 0.6,
          options = {},
        },
        strategies = {
          integrated = {
            height = 40,
            width = 120,
          },
        },
      }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)
    end,
  },
}
