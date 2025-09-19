-- MARVIM Plugin Helper
-- Provides easy access to framework modules for plugin configurations
-- This module serves as a bridge for migrated plugins to access framework features

local M = {}

-- Cache for framework instance
local marvim = nil

-- Get or initialize the framework instance
local function get_marvim()
  if not marvim then
    local ok, framework = pcall(require, "marvim")
    if ok then
      marvim = framework
    else
      -- Fallback to empty stub if framework not available
      marvim = {
        module = { safe_require = function(name) return pcall(require, name) end },
        autocmd = { create = vim.api.nvim_create_autocmd, group = vim.api.nvim_create_augroup },
        event = { emit = function() end, on = function() end },
        utils = {},
      }
    end
  end
  return marvim
end

-- Safe require with framework module system
function M.safe_require(module_name, opts)
  local framework = get_marvim()
  if framework and framework.module then
    local module_system = framework.module()
    if module_system and module_system.load then
      return module_system.load(module_name, opts)
    end
  end
  -- Fallback to pcall
  local ok, result = pcall(require, module_name)
  return ok and result or nil
end

-- Try to load a module, returning success status and module
function M.try_require(module_name, opts)
  local framework = get_marvim()
  if framework and framework.module then
    local module_system = framework.module()
    if module_system and module_system.try_load then
      return module_system.try_load(module_name, opts)
    end
  end
  -- Fallback to pcall
  local ok, result = pcall(require, module_name)
  return ok, result
end

-- Get autocmd module or create autocmd directly
function M.autocmd(event, opts)
  -- If called without arguments, return the autocmd module
  if event == nil and opts == nil then
    local framework = get_marvim()
    if framework and framework.autocmd then
      return framework.autocmd()
    end
    -- Return a fallback module interface
    return {
      create = vim.api.nvim_create_autocmd,
      create_group = vim.api.nvim_create_augroup,
    }
  end

  -- If called with arguments, create an autocmd directly
  local framework = get_marvim()
  if framework and framework.autocmd then
    local autocmd_system = framework.autocmd()
    if autocmd_system and autocmd_system.create then
      return autocmd_system.create(event, opts)
    end
  end
  -- Fallback to direct API
  return vim.api.nvim_create_autocmd(event, opts)
end

-- Create autocmd group with framework
function M.augroup(name, opts)
  local framework = get_marvim()
  if framework and framework.autocmd then
    local autocmd_system = framework.autocmd()
    if autocmd_system and autocmd_system.group then
      return autocmd_system.group(name, opts)
    end
  end
  -- Fallback to direct API
  return vim.api.nvim_create_augroup(name, opts or { clear = true })
end

-- Emit event with framework
function M.emit_event(name, ...)
  local framework = get_marvim()
  if framework and framework.event then
    local event_system = framework.event()
    if event_system and event_system.emit then
      return event_system.emit(name, ...)
    end
  end
end

-- Subscribe to event with framework
function M.on_event(name, callback, opts)
  local framework = get_marvim()
  if framework and framework.event then
    local event_system = framework.event()
    if event_system and event_system.on then
      return event_system.on(name, callback, opts)
    end
  end
end

-- Check if a feature is enabled
function M.is_enabled(feature)
  local framework = get_marvim()
  if framework and framework.config then
    local config = framework.config()
    if config and config.get then
      local cfg = config.get()
      if cfg and cfg.features then
        return cfg.features[feature] == true
      end
    end
  end
  -- Default to enabled if can't determine
  return true
end

-- Get configuration value
function M.get_config(path, default)
  local framework = get_marvim()
  if framework and framework.config then
    local config = framework.config()
    if config and config.get_value then
      return config.get_value(path, default)
    end
  end
  return default
end

-- Export for backward compatibility
M.module = {
  safe_require = M.safe_require,
  try_require = M.try_require,
}

-- Don't override the autocmd function with a table

M.event = {
  emit = M.emit_event,
  on = M.on_event,
}

M.config = {
  is_enabled = M.is_enabled,
  get = M.get_config,
}

return M