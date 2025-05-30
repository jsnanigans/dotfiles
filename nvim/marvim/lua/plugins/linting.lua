-- Nvim-lint - Asynchronous linting for better code quality
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configure linters by filetype
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      vue = { "eslint_d" },
      python = { "pylint", "flake8" },
      dockerfile = { "hadolint" },
      yaml = { "yamllint" },
      json = { "jsonlint" },
      lua = { "luacheck" },
      bash = { "shellcheck" },
      sh = { "shellcheck" },
      zsh = { "shellcheck" },
    }

    -- Custom linter configurations
    lint.linters.eslint_d.args = {
      "--no-warn-ignored",
      "--format",
      "json",
      "--stdin",
      "--stdin-filename",
      function()
        return vim.api.nvim_buf_get_name(0)
      end,
    }

    -- Custom luacheck config for Neovim
    lint.linters.luacheck.args = {
      "--globals",
      "vim",
      "--no-color",
      "--codes",
      "--ranges",
      "--formatter",
      "plain",
      "-",
    }

    -- Create autocommand for linting
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        -- Only lint if file is readable and has a valid filetype
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.bo[bufnr].filetype
        
        -- Skip linting for certain buffer types
        if vim.bo[bufnr].buftype ~= "" then
          return
        end
        
        -- Skip if no linters configured for this filetype
        if not lint.linters_by_ft[filetype] then
          return
        end
        
        lint.try_lint()
      end,
    })

    -- Manual lint command
    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })

    -- Keymaps
    local keymap = vim.keymap.set
    keymap("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
} 