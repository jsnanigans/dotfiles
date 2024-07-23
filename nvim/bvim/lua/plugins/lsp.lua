return {
  -- {
  --   'SmiteshP/nvim-navic',
  --   dependencies = { 'neovim/nvim-lspconfig' },
  --   config = function()
  --     local navic = require 'nvim-navic'
  --     navic.setup {
  --       lsp = { auto_attach = true },
  --     }
  --   end,
  -- },
  {
    'williamboman/mason.nvim',
    lazy = false,
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'neovim/nvim-lspconfig' },
      },
      -- 'SmiteshP/nvim-navic',
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local servers = {
        'lua_ls',
        -- 'vtsls',
        'tsserver',
        'eslint',
        'biome',
        'typos_lsp',
        'astro',
        'jdtls',
      }

      local function organize_imports()
        local params = {
          command = '_typescript.organizeImports',
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = '',
        }
        vim.lsp.buf.execute_command(params)
      end

      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = servers,
      }

      local lspconfig = require 'lspconfig'
      -- local navic = require 'nvim-navic'
      lspconfig.sourcekit.setup {
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      }

      local onAttach = {
        -- eslint = function(client, bufnr)
        --   vim.api.nvim_create_autocmd('BufWritePre', {
        --     buffer = bufnr,
        --     command = 'EslintFixAll',
        --   })
        -- end,
        -- biome = function(client, bufnr)
        --   vim.api.nvim_create_autocmd('BufWritePre', {
        --     buffer = bufnr,
        --     command = 'BiomeFormat',
        --   })
        -- end,
      }
      local commands = {
        tsserver = {
          OrganizeImports = {
            organize_imports,
            description = 'Organize Imports',
          },
        },
      }
      local init_options = {
        typos_lsp = {
          cmd_env = { RUST_LOG = 'error' },
          init_options = {
            -- Custom config. Used together with any workspace config files, taking precedence for
            -- settings declared in both. Equivalent to the typos `--config` cli argument.
            config = '/Users/bdan/.config/typos.toml',
            -- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
            -- Defaults to error.
            diagnosticSeverity = 'Error',
          },
        },
      }

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          on_attach = function(client, bufnr)
            local oa = onAttach[lsp]
            if oa then
              oa(client, bufnr)
            end
            -- if client.server_capabilities.documentSymbolProvider then
            --   navic.attach(client, bufnr)
            -- end
          end,
          capabilities = capabilities,
          commands = commands[lsp],
          init_options = init_options[lsp],
        }
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach-keymaps', { clear = true }),
        callback = function(event)
          require('config.keymaps').setup_lsp_keymaps(event)
        end,
      })
    end,
  },
  {
    'j-hui/fidget.nvim',
    opts = {
      -- options
    },
  },
}
