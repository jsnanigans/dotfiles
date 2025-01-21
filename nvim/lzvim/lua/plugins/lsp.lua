
---@diagnostic disable: missing-fields
return {
    -- lsp servers
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            require 'lspconfig'.vtsls.setup {}

            require("lspconfig").eslint.setup({
              settings = {}
            })

            require'lspconfig'.lua_ls.setup{}

            require('config.keymaps').setup_vtsls_keymaps()
        end,
        opts = {
          servers = {
            tsserver = {
              enabled = false,
            },
            ts_ls = {
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
          }
        }
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
    },

    {
        "stevearc/conform.nvim",
        -- This will provide type hinting with LuaLS
        ---@module "conform"
        ---@type conform.setupOpts
        opts = {
            formatters_by_ft = {
                ["javascript"] = { "prettierd", "prettier" },
                ["javascriptreact"] = { "prettierd", "prettier" },
                ["typescript"] = { "prettierd", "prettier" },
                ["typescriptreact"] = { "prettierd", "prettier" },
            },
            -- formatters_by_ft = {
            --   ["javascript"] = { "dprint", { "prettierd", "prettier" } },
            --   ["javascriptreact"] = { "dprint" },
            --   ["typescript"] = { "dprint", { "prettierd", "prettier" } },
            --   ["typescriptreact"] = { "dprint" },
            -- },
            -- formatters = {
            --   dprint = {
            --     condition = function(_, ctx)
            --       return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
            --     end,
            --   },
            -- },
        },
    },
    -- {
    --   "mfussenegger/nvim-lint",
    --   opts = {
    --     linters_by_ft = {
    --       lua = { "selene", "luacheck" },
    --     },
    --     linters = {
    --       selene = {
    --         condition = function(ctx)
    --           local root = LazyVim.root.get({ normalize = true })
    --           if root ~= vim.uv.cwd() then
    --             return false
    --           end
    --           return vim.fs.find({ "selene.toml" }, { path = root, upward = true })[1]
    --         end,
    --       },
    --       luacheck = {
    --         condition = function(ctx)
    --           local root = LazyVim.root.get({ normalize = true })
    --           if root ~= vim.uv.cwd() then
    --             return false
    --           end
    --           return vim.fs.find({ ".luacheckrc" }, { path = root, upward = true })[1]
    --         end,
    --       },
    --     },
    --   },
    -- },
}
