-- Lazy.nvim configuration using MARVIM framework
local marvim = require("marvim")
local module = marvim.module()
local plugin = marvim.plugin()
local event = marvim.event()

-- Create lazy config module
local M = module.create("config.lazy")

-- Define lazy.nvim spec with framework integration
local function get_spec()
  return {
    -- Import all plugin categories directly
    { import = "config.plugins.core" },
    { import = "config.plugins.editor" },
    { import = "config.plugins.coding" },
    { import = "config.plugins.git" },
    { import = "config.plugins.lsp" },
    { import = "config.plugins.navigation" },
    { import = "config.plugins.ui" },
    { import = "config.plugins.testing" },
    { import = "config.plugins.extras" },
  }
end

-- Setup function
function M.setup()
  -- Use framework's safe_require for lazy.nvim
  local lazy = module.safe_require("lazy")
  if not lazy then
    vim.notify("Failed to load lazy.nvim", vim.log.levels.ERROR)
    return
  end

  -- Emit pre-setup event
  event.emit("LazyPreSetup")

  -- Setup lazy.nvim with framework integration
  lazy.setup({
    spec = get_spec(),

    defaults = {
      lazy = true,
      version = false,
    },

    install = {
      colorscheme = { "github-dark-colorblind", "flexoki-dark", "habamax" },
    },

    checker = {
      enabled = true,
      notify = false,
    },

    performance = {
      cache = {
        enabled = true,
      },
      rtp = {
        -- Use framework's optimization list
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
          "2html_plugin",
          "getscript",
          "getscriptPlugin",
          "logipat",
          "rrhelper",
          "spellfile_plugin",
          "vimball",
          "vimballPlugin",
        },
      },
    },

    ui = {
      border = "rounded",
      backdrop = 60,
      size = {
        width = 0.8,
        height = 0.8,
      },
    },

    dev = {
      path = "~/projects",
      patterns = {},
      fallback = false,
    },

    -- Hook into lazy events with framework
    init = function()
      -- Emit event when lazy starts initializing
      event.emit("LazyInit")
    end,

    config = function()
      -- Emit event when lazy finishes loading
      event.emit("LazyComplete")

      -- Register lazy.nvim with plugin manager
      plugin.register({
        name = "lazy.nvim",
        manager = lazy,
        type = "manager",
      })
    end,
  })

  -- Emit post-setup event
  event.emit("LazyPostSetup")
end

-- Initialize if not already done via framework
if not marvim.is_initialized() then
  -- Direct call for backward compatibility
  M.setup()
else
  -- Register setup for deferred execution
  module.register(M)
end

return M