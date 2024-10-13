-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "lua_ls", "vtsls", "eslint", "typos_lsp" }
local nvlspConf = require "nvchad.configs.lspconfig"

local lspAttach = function (client, bufnr)
  nvlspConf.on_attach(client, bufnr)
  require("mappings").setup_lsp_keymaps(bufnr)
end

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = lspAttach,
    on_init = nvlspConf.on_init,
    capabilities = nvlspConf.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
