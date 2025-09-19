-- Mason LSP installer configuration using MARVIM framework
local marvim = require("marvim")
local module = marvim.module()
local event = marvim.event()
local plugin = marvim.plugin()

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "google-java-format",
        "json-lsp",
        "prettier",
        "ruff",
        "ruff-lsp",
        "eslint_d",
        "codelldb",
        "js-debug-adapter",
      },
    },
    config = function(_, opts)
      -- Use framework's safe_require for mason
      local mason = module.load("mason")
      if not mason then
        vim.notify("Failed to load mason.nvim", vim.log.levels.ERROR)
        return
      end

      mason.setup(opts)

      -- Use framework's safe_require for mason-registry
      local mr = module.load("mason-registry")
      if not mr then
        vim.notify("Failed to load mason-registry", vim.log.levels.ERROR)
        return
      end

      -- Hook into package installation success
      mr:on("package:install:success", function(pkg)
        -- Emit framework event for package installation
        event.emit("MasonPackageInstalled", { package = pkg })

        -- Trigger FileType event to reload LSP for current buffer
        local lazy_event = module.load("lazy.core.handler.event")
        if lazy_event then
          lazy_event.trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end
      end)

      -- Defer package installation to avoid blocking startup
      vim.defer_fn(function()
        local function ensure_installed()
          for _, tool in ipairs(opts.ensure_installed) do
            local ok, p = pcall(mr.get_package, mr, tool)
            if ok and p and not p:is_installed() then
              -- Emit event before installation
              event.emit("MasonPackageInstalling", { tool = tool })
              p:install()
            end
          end
        end

        if mr.refresh then
          mr.refresh(ensure_installed)
        else
          ensure_installed()
        end
      end, 100)

      -- Emit setup complete event
      event.emit("MasonSetupComplete")
    end,
  },
}