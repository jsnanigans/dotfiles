return {
  -- Mini.diff for showing git changes in signcolumn
  {
    "echasnovski/mini.diff",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      view = {
        style = "sign",
        signs = {
          add = "▎",
          change = "▎",
          delete = "",
        },
        priority = 199,
      },
      source = nil, -- Auto-detect
      delay = {
        text_change = 200,
      },
      mappings = {
        apply = "gh",
        reset = "gH",
        textobject = "gh",
        goto_first = "[H",
        goto_prev = "[h",
        goto_next = "]h",
        goto_last = "]H",
      },
    },
    config = function(_, opts)
      require("mini.diff").setup(opts)
      
      -- Set up autocmd to update summary for statusline
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniDiffUpdated",
        callback = function(args)
          local summary = vim.b[args.buf].minidiff_summary
          vim.b[args.buf].minidiff_summary = summary
        end,
      })
      
      -- Create commands for compatibility
      vim.api.nvim_create_user_command("MiniDiffToggle", function()
        require("mini.diff").toggle()
      end, { desc = "Toggle mini.diff" })
      vim.api.nvim_create_user_command("MiniDiffOverlay", function()
        require("mini.diff").toggle_overlay()
      end, { desc = "Toggle mini.diff overlay" })
      
      -- Git conflict resolution commands (replacing git-conflict.nvim)
      -- These work without mini.git which is still experimental
      vim.api.nvim_create_user_command("GitConflictChooseOurs", function()
        -- Find conflict markers
        local start_line = vim.fn.search("^<<<<<<<", "bnW")
        local middle_line = vim.fn.search("^=======", "nW")
        local end_line = vim.fn.search("^>>>>>>>", "nW")
        
        if start_line > 0 and middle_line > 0 and end_line > 0 then
          -- Keep only our version (before =======)
          vim.api.nvim_buf_set_lines(0, middle_line - 1, end_line, false, {})
          vim.api.nvim_buf_set_lines(0, start_line - 1, start_line, false, {})
        end
      end, { desc = "Choose our version in conflict" })

      vim.api.nvim_create_user_command("GitConflictChooseTheirs", function()
        -- Find conflict markers
        local start_line = vim.fn.search("^<<<<<<<", "bnW")
        local middle_line = vim.fn.search("^=======", "nW")
        local end_line = vim.fn.search("^>>>>>>>", "nW")
        
        if start_line > 0 and middle_line > 0 and end_line > 0 then
          -- Keep only their version (after =======)
          vim.api.nvim_buf_set_lines(0, end_line - 1, end_line, false, {})
          vim.api.nvim_buf_set_lines(0, start_line - 1, middle_line, false, {})
        end
      end, { desc = "Choose their version in conflict" })

      vim.api.nvim_create_user_command("GitConflictChooseBoth", function()
        -- Find and remove conflict markers
        local start_line = vim.fn.search("^<<<<<<<", "bnW")
        local middle_line = vim.fn.search("^=======", "nW")
        local end_line = vim.fn.search("^>>>>>>>", "nW")
        
        if start_line > 0 and middle_line > 0 and end_line > 0 then
          -- Remove conflict markers, keeping both versions
          vim.api.nvim_buf_set_lines(0, end_line - 1, end_line, false, {})
          vim.api.nvim_buf_set_lines(0, middle_line - 1, middle_line, false, {})
          vim.api.nvim_buf_set_lines(0, start_line - 1, start_line, false, {})
        end
      end, { desc = "Keep both versions in conflict" })

      vim.api.nvim_create_user_command("GitConflictChooseNone", function()
        -- Find and remove entire conflict
        local start_line = vim.fn.search("^<<<<<<<", "bnW")
        local end_line = vim.fn.search("^>>>>>>>", "nW")
        
        if start_line > 0 and end_line > 0 then
          vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {})
        end
      end, { desc = "Remove entire conflict" })

      -- Navigation commands for conflicts
      vim.api.nvim_create_user_command("GitConflictNextConflict", function()
        vim.fn.search("^<<<<<<<", "W")
      end, { desc = "Go to next conflict" })

      vim.api.nvim_create_user_command("GitConflictPrevConflict", function()
        vim.fn.search("^<<<<<<<", "bW")
      end, { desc = "Go to previous conflict" })
    end,
  },
}