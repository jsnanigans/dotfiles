return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  config = function()
    local jsFmt = { { 'prettierd', 'prettier' } }
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Use a sub-list to run only the first available formatter
        typescript = jsFmt,
        typescriptreact = jsFmt,
        javascript = jsFmt,
        javascriptreact = jsFmt,
        ['*'] = { 'codespell', 'trim_whitespace' },
      },
    }

    -- vim.api.nvim_create_autocmd('BufWritePre', {
    --   pattern = '*',
    --   callback = function(args)
    --     require('conform').format { bufnr = args.buf, lsp_fallback = true }
    --   end,
    -- })
    vim.keymap.set('n', '<leader>cf', function()
      require('conform').format { bufnr = vim.api.nvim_get_current_buf(), lsp_fallback = true, timeout_ms = 10000 }
    end, { desc = 'Format Buffer' })
  end,
}
