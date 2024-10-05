local jsFmt = { { 'prettierd', 'prettier' } }
local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = jsFmt,
    typescript = jsFmt,
    typescriptreact = jsFmt,
    javascriptreact = jsFmt
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
