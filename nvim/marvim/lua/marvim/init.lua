-- MARVIM Framework Core
-- Provides the central namespace and initialization for the MARVIM framework

local M = {}

-- Framework version for debugging and compatibility checks
M.version = "1.0.0"

-- Core modules that will be lazily loaded
local modules = {
  config = nil,
  module = nil,
  utils = nil,
  autocmd = nil,
  -- Phase 2 feature systems
  toggle = nil,
  event = nil,
  plugin = nil,
  cache = nil,
}

-- Module loader with caching
local function load_module(name)
  if not modules[name] then
    local ok, mod = pcall(require, "marvim." .. name)
    if ok then
      modules[name] = mod
    else
      vim.notify("Failed to load marvim." .. name .. ": " .. tostring(mod), vim.log.levels.ERROR)
      return nil
    end
  end
  return modules[name]
end

-- Export module accessors
M.config = function() return load_module("config") end
M.module = function() return load_module("module") end
M.utils = function() return load_module("utils") end
M.autocmd = function() return load_module("autocmd") end
-- Phase 2 feature systems
M.toggle = function() return load_module("toggle") end
M.event = function() return load_module("event") end
M.plugin = function() return load_module("plugin") end
M.cache = function() return load_module("cache") end

-- Framework initialization
function M.setup(opts)
  opts = opts or {}

  -- Initialize core modules in order
  local config = M.config()
  if config then
    config.setup(opts.config or {})
  end

  -- Initialize autocmd manager early for other modules to use
  local autocmd = M.autocmd()
  if autocmd then
    autocmd.setup()
  end

  -- Initialize Phase 2 feature systems
  local event = M.event()
  if event then
    event.setup_common()
    if opts.commands ~= false then
      event.setup_commands()
    end
  end

  local toggle = M.toggle()
  if toggle then
    toggle.setup_common()
    if opts.commands ~= false then
      toggle.setup_commands()
    end
  end

  local cache = M.cache()
  if cache then
    cache.setup_common()
    if opts.commands ~= false then
      cache.setup_commands()
    end
  end

  local plugin = M.plugin()
  if plugin and opts.commands ~= false then
    plugin.setup_commands()
  end

  -- Set up performance optimizations
  if opts.optimize ~= false then
    M.optimize()
  end

  -- Mark framework as initialized
  M.initialized = true

  -- Emit initialization event
  vim.api.nvim_exec_autocmds("User", { pattern = "MarvimInitialized" })
end

-- Performance optimizations
function M.optimize()
  -- Disable some builtin plugins for faster startup
  local disabled_built_ins = {
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
  }

  for _, plugin in ipairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
  end
end

-- Check if framework is initialized
function M.is_initialized()
  return M.initialized == true
end

-- Debugging helper
function M.debug()
  local info = {
    version = M.version,
    initialized = M.initialized,
    loaded_modules = {},
    config = {},
    feature_systems = {},
  }

  for name, mod in pairs(modules) do
    if mod then
      info.loaded_modules[name] = true
      if name == "config" and mod.get then
        info.config = mod.get()
      elseif mod.debug then
        info.feature_systems[name] = mod.debug()
      end
    end
  end

  return info
end

return M