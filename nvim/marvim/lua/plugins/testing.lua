-- Neotest - Testing framework for Neovim
return {
  "nvim-neotest/neotest",
  cmd = { "Neotest" },
  keys = {
    { "<leader>tt", desc = "Run nearest test" },
    { "<leader>tf", desc = "Run tests in current file" },
    { "<leader>td", desc = "Debug nearest test" },
    { "<leader>tl", desc = "Run last test" },
    { "<leader>tS", desc = "Toggle test summary" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/nvim-nio",
    -- Language-specific adapters
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-python",
    "rouge8/neotest-rust",
    "nvim-neotest/neotest-go",
  },
  config = function()
    local neotest = require("neotest")
    
    neotest.setup({
      adapters = {
        -- JavaScript/TypeScript testing
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        }),
        require("neotest-vitest")({
          vitestCommand = "npm exec vitest",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        }),
        
        -- Python testing
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest",
          python = "python3",
        }),
        
        -- Rust testing
        require("neotest-rust")({
          args = { "--no-capture" },
        }),
        
        -- Go testing
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          args = { "-count=1", "-timeout=60s" },
        }),
      },
      
      -- Global configuration
      discovery = {
        enabled = true,
        concurrent = 5,
      },
      
      running = {
        concurrent = true,
      },
      
      summary = {
        enabled = true,
        animated = true,
        follow = true,
        expand_errors = true,
        open = "botright vsplit | vertical resize 50",
      },
      
      output = {
        enabled = true,
        open_on_run = "short",
      },
      
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },
      
      quickfix = {
        enabled = true,
        open = false,
      },
      
      status = {
        enabled = true,
        virtual_text = false,
        signs = true,
      },
      
      strategies = {
        integrated = {
          height = 40,
          width = 120,
        },
      },
      
      -- Icons for test states
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "╮",
        failed = "",
        final_child_indent = " ",
        final_child_prefix = "╰",
        non_collapsible = "─",
        passed = "",
        running = "",
        running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
        skipped = "",
        unknown = "",
        watching = "",
      },
      
      -- Floating window configuration
      floating = {
        border = "rounded",
        max_height = 0.6,
        max_width = 0.6,
        options = {},
      },
      
      -- Highlights
      highlights = {
        adapter_name = "NeotestAdapterName",
        border = "NeotestBorder",
        dir = "NeotestDir",
        expand_marker = "NeotestExpandMarker",
        failed = "NeotestFailed",
        file = "NeotestFile",
        focused = "NeotestFocused",
        indent = "NeotestIndent",
        marked = "NeotestMarked",
        namespace = "NeotestNamespace",
        passed = "NeotestPassed",
        running = "NeotestRunning",
        select_win = "NeotestWinSelect",
        skipped = "NeotestSkipped",
        target = "NeotestTarget",
        test = "NeotestTest",
        unknown = "NeotestUnknown",
        watching = "NeotestWatching",
      },
    })

    -- Keymaps
    local keymap = vim.keymap.set
    
    -- Test running
    keymap("n", "<leader>tt", function() neotest.run.run() end, { desc = "Run nearest test" })
    keymap("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run tests in current file" })
    keymap("n", "<leader>td", function() neotest.run.run({strategy = "dap"}) end, { desc = "Debug nearest test" })
    keymap("n", "<leader>tl", function() neotest.run.run_last() end, { desc = "Run last test" })
    keymap("n", "<leader>tL", function() neotest.run.run_last({strategy = "dap"}) end, { desc = "Debug last test" })
    
    -- Test management
    keymap("n", "<leader>ts", function() neotest.run.stop() end, { desc = "Stop running tests" })
    keymap("n", "<leader>ta", function() neotest.run.attach() end, { desc = "Attach to running test" })
    
    -- Test navigation
    keymap("n", "[t", function() neotest.jump.prev({ status = "failed" }) end, { desc = "Jump to previous failed test" })
    keymap("n", "]t", function() neotest.jump.next({ status = "failed" }) end, { desc = "Jump to next failed test" })
    
    -- Test UI
    keymap("n", "<leader>to", function() neotest.output.open({ enter = true, auto_close = true }) end, { desc = "Show test output" })
    keymap("n", "<leader>tO", function() neotest.output_panel.toggle() end, { desc = "Toggle test output panel" })
    keymap("n", "<leader>tS", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
    
    -- Watch mode
    keymap("n", "<leader>tw", function() neotest.watch.toggle() end, { desc = "Toggle watch mode" })
    keymap("n", "<leader>tW", function() neotest.watch.toggle(vim.fn.expand("%")) end, { desc = "Toggle watch mode for current file" })
  end,
} 