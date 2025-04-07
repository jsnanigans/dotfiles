---@diagnostic disable: missing-fields
return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    lazy = false,
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
    end,
  },
  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.vtsls.setup {}
      lspconfig.eslint.setup({})
      lspconfig.lua_ls.setup({})
      -- lspconfig.stylua.setup({})
      lspconfig.basedpyright.setup({})
      lspconfig.ruff.setup({})
      lspconfig.typos_lsp.setup({})
      lspconfig.bashls.setup({})
      lspconfig.jsonls.setup({})
      -- lspconfig.ts_ls.setup({})

      require('config.keymaps').setup_vtsls_keymaps()
    end,
    opts = {
      servers = {
        tsserver = {
          enabled = false,
        },
        -- ts_ls = {
        --   enabled = false,
        --   filetypes = {
        --     "javascript",
        --     "javascriptreact",
        --     "javascript.jsx",
        --     "typescript",
        --     "typescriptreact",
        --     "typescript.tsx",
        --   },
        -- },
        typos_lsp = {
          enabled = false,
        },
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          }
        }
      },
      setup = {
        --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
        --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
        tsserver = function()
          -- disable tsserver
          return true
        end,
        ts_ls = function()
          -- disable tsserver
          return true
        end,
      },
    },
    -- opts = {
    --     diagnostics = { virtual_text = { prefix = "icons" } },
    --     inlay_hints = {
    --         enabled = false,
    --     },
    --     capabilities = {
    --         workspace = {
    --             didChangeWatchedFiles = {
    --                 dynamicRegistration = false,
    --             },
    --         },
    --     },
    --     ---@type lspconfig.options
    --     servers = {
    --         lua_ls = {
    --             -- cmd = { "/home/folke/projects/lua-language-server/bin/lua-language-server" },
    --             -- single_file_support = true,
    --             settings = {
    --                 Lua = {
    --                     misc = {
    --                         -- parameters = { "--loglevel=trace" },
    --                     },
    --                     -- hover = { expandAlias = false },
    --                     type = {
    --                         castNumberToInteger = true,
    --                     },
    --                     diagnostics = {
    --                         disable = { "incomplete-signature-doc", "trailing-space" },
    --                         -- enable = false,
    --                         groupSeverity = {
    --                             strong = "Warning",
    --                             strict = "Warning",
    --                         },
    --                         groupFileStatus = {
    --                             ["ambiguity"] = "Opened",
    --                             ["await"] = "Opened",
    --                             ["codestyle"] = "None",
    --                             ["duplicate"] = "Opened",
    --                             ["global"] = "Opened",
    --                             ["luadoc"] = "Opened",
    --                             ["redefined"] = "Opened",
    --                             ["strict"] = "Opened",
    --                             ["strong"] = "Opened",
    --                             ["type-check"] = "Opened",
    --                             ["unbalanced"] = "Opened",
    --                             ["unused"] = "Opened",
    --                         },
    --                         unusedLocalExclude = { "_*" },
    --                     },
    --                 },
    --             },
    --         },
    --     },
    -- },
  }
}
