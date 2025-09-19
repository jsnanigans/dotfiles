-- LSP configuration using MARVIM framework
local marvim = require("marvim")
local module = marvim.module()
local autocmd = marvim.autocmd()
local event = marvim.event()
local plugin = marvim.plugin()

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      "mason-org/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- Add delay for better performance
          delay = 300,
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        -- Float window appears after delay
        float = {
          delay = 300,
        },
      },
      inlay_hints = {
        enabled = true,
      },
      codelens = {
        enabled = true,
      },
      document_highlight = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        ts_ls = {
          enabled = false,
        },
      },
      setup = {
        ts_ls = function()
          return true
        end,
      },
    },
    config = function(_, opts)
      -- Emit pre-setup event
      event.emit("LspPreSetup")

      -- Configure LSP handlers with borders
      vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
        config = config or {}
        config.border = config.border or "rounded"
        config.winhighlight = config.winhighlight or "NormalFloat:NormalFloat,FloatBorder:FloatBorder"
        if
          not result
          or not result.contents
          or (type(result.contents) == "table" and vim.tbl_isempty(result.contents))
          or (type(result.contents) == "string" and result.contents == "")
        then
          return
        end
        return vim.lsp.handlers.hover(_, result, ctx, config)
      end

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      })

      vim.diagnostic.config({
        float = {
          border = "rounded",
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      })

      -- Use framework's safe_require for utilities
      local Util = module.safe_require("utils.lsp")
      if not Util then
        vim.notify("Failed to load LSP utilities", vim.log.levels.ERROR)
        return
      end

      Util.setup()
      Util.on_attach(function(client, buffer)
        -- Emit LspAttach event via framework
        event.emit("LspAttach", { client = client, buffer = buffer })

        -- Setup keybindings using framework's safe_require
        local keymaps = module.safe_require("config.keymaps")
        if keymaps and keymaps.setup_lsp_keybindings then
          keymaps.setup_lsp_keybindings(client, buffer)
        end
      end)

      -- Use framework's safe_require for LSP modules
      local lsp_cache = module.safe_require("utils.lsp_cache")
      local server_configs = module.safe_require("utils.lsp_servers")

      if not lsp_cache or not server_configs then
        vim.notify("Failed to load LSP modules", vim.log.levels.ERROR)
        return
      end

      -- Use cached capabilities for performance
      local capabilities = vim.tbl_deep_extend("force", lsp_cache.get_capabilities(), opts.capabilities or {})

      -- Merge lazy-loaded server configs with opts.servers
      local servers = vim.tbl_deep_extend("force", {
        lua_ls = server_configs.get_server_config("lua_ls"),
        vtsls = server_configs.get_server_config("vtsls"),
        eslint = server_configs.get_server_config("eslint"),
        jsonls = server_configs.get_server_config("jsonls"),
        clangd = server_configs.get_server_config("clangd"),
        basedpyright = server_configs.get_server_config("basedpyright"),
        ruff = server_configs.get_server_config("ruff"),
        dartls = server_configs.get_server_config("dartls"),
      }, opts.servers)

      local function setup(server)
        if server == "ts_ls" then
          return
        end
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end

        -- Use framework's safe_require for lspconfig
        local lspconfig = module.safe_require("lspconfig")
        if lspconfig then
          lspconfig[server].setup(server_opts)
        end
      end

      -- Use framework's safe_require for mason
      local mlsp = module.safe_require("mason-lspconfig")
      local all_mslp_servers = {}
      if mlsp then
        all_mslp_servers = mlsp.get_available_servers()
      end

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled == false then
            goto continue
          end
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
        ::continue::
      end

      if mlsp then
        mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
      end

      vim.diagnostic.config(vim.deepcopy(Util.get_config("diagnostics")))

      -- Defer heavy features until buffer is actually used (using framework's autocmd)
      autocmd.create({ "CursorHold", "CursorHoldI" }, {
        group = autocmd.group("lsp_deferred_features", { clear = true }),
        once = true,
        callback = function()
          local inlay_hint = Util.get_config("inlay_hints")
          if inlay_hint.enabled then
            Util.on_attach(function(client, buffer)
              if client:supports_method("textDocument/inlayHint") then
                vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
              end
            end)
          end

          local codelens = Util.get_config("codelens")
          if codelens.enabled then
            Util.on_attach(function(client, buffer)
              if client:supports_method("textDocument/codeLens") then
                vim.defer_fn(function()
                  if vim.api.nvim_buf_is_valid(buffer) then
                    local codelens_augroup = autocmd.group("lsp_codelens_" .. buffer, { clear = true })

                    -- Safe call to refresh codelens
                    local ok, err = pcall(vim.lsp.codelens.refresh, { bufnr = buffer })
                    if not ok then
                      vim.notify("Failed to refresh codelens: " .. tostring(err), vim.log.levels.WARN)
                    end

                    -- Debounced codelens refresh
                    local refresh_timer = nil
                    local function debounced_refresh()
                      if refresh_timer then
                        vim.fn.timer_stop(refresh_timer)
                      end
                      refresh_timer = vim.fn.timer_start(500, function()
                        if vim.g.codelens_enabled ~= false and vim.api.nvim_buf_is_valid(buffer) then
                          local ok2, err2 = pcall(vim.lsp.codelens.refresh, { bufnr = buffer })
                          if not ok2 then
                            vim.notify("Failed to refresh codelens: " .. tostring(err2), vim.log.levels.WARN)
                          end
                        end
                      end)
                    end

                    -- Use framework's autocmd for codelens refresh
                    autocmd.create({ "TextChanged", "InsertLeave" }, {
                      group = codelens_augroup,
                      buffer = buffer,
                      callback = debounced_refresh,
                    })

                    autocmd.create({ "CursorHold", "CursorHoldI" }, {
                      group = codelens_augroup,
                      buffer = buffer,
                      callback = function()
                        if vim.g.codelens_enabled ~= false and vim.api.nvim_buf_is_valid(buffer) then
                          local ok3, err3 = pcall(vim.lsp.codelens.refresh, { bufnr = buffer })
                          if not ok3 then
                            vim.notify("Failed to refresh codelens: " .. tostring(err3), vim.log.levels.WARN)
                          end
                        end
                      end,
                    })
                  end
                end, 100)
              end
            end)
          end

          local document_highlight = Util.get_config("document_highlight")
          if document_highlight.enabled then
            Util.on_attach(function(client, buffer)
              if client:supports_method("textDocument/documentHighlight") then
                local highlight_augroup = autocmd.group("lsp_document_highlight_" .. buffer, { clear = true })

                autocmd.create({ "CursorHold", "CursorHoldI" }, {
                  group = highlight_augroup,
                  buffer = buffer,
                  callback = vim.lsp.buf.document_highlight,
                })

                autocmd.create({ "CursorMoved", "CursorMovedI" }, {
                  group = highlight_augroup,
                  buffer = buffer,
                  callback = vim.lsp.buf.clear_references,
                })
              end
            end)
          end
        end,
      })

      -- Emit post-setup event
      event.emit("LspPostSetup")

      -- Register with plugin manager
      plugin.register({
        name = "nvim-lspconfig",
        type = "lsp",
        config = opts,
      })
    end,
  },
}