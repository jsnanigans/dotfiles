-- MARVIM Config API
-- Unified configuration management with defaults, merging, and validation

local M = {}

-- Default configuration structure
local defaults = {
  -- Feature flags
  features = {
    copilot = false,
    snippets = true,
    dap = true,
    testing = true,
    lsp = true,
    treesitter = true,
    telescope = true,
    git = true,
  },

  -- LSP configuration
  lsp = {
    format_on_save = true,
    virtual_text = "mini",  -- "full", "mini", "off"
    diagnostic_float = true,
    semantic_tokens = true,
    code_lens = true,
    inlay_hints = false,
    servers = {},  -- Server-specific overrides
  },

  -- UI configuration
  ui = {
    theme = "nord",
    transparency = false,
    icons = true,
    animate = true,
    border = "rounded",  -- "single", "double", "rounded", "none"
    winbar = true,
    statusline = true,
  },

  -- Performance settings
  performance = {
    lazy_load = true,
    cache = true,
    compile = true,
    startup_optimize = true,
  },

  -- Path configurations
  paths = {
    data = vim.fn.stdpath("data"),
    cache = vim.fn.stdpath("cache"),
    config = vim.fn.stdpath("config"),
  },

  -- Custom user configuration
  custom = {},
}

-- Current active configuration
local config = {}

-- Configuration watchers for reactive updates
local watchers = {}

-- Deep merge tables with proper handling of arrays and nested tables
local function deep_merge(base, override)
  if type(override) ~= "table" then
    return override
  end

  local result = vim.tbl_deep_extend("force", {}, base or {})

  for key, value in pairs(override) do
    if type(value) == "table" and type(result[key]) == "table" then
      -- Special handling for arrays vs maps
      if vim.islist(value) then
        result[key] = value  -- Replace arrays completely
      else
        result[key] = deep_merge(result[key], value)
      end
    else
      result[key] = value
    end
  end

  return result
end

-- Validate configuration against schema
local function validate(conf)
  local ok, err = pcall(function()
    vim.validate({
      features = { conf.features, "table", true },
      lsp = { conf.lsp, "table", true },
      ui = { conf.ui, "table", true },
      performance = { conf.performance, "table", true },
      paths = { conf.paths, "table", true },
    })

    -- Validate specific values
    if conf.lsp and conf.lsp.virtual_text then
      local valid_values = { "full", "mini", "off" }
      assert(
        vim.tbl_contains(valid_values, conf.lsp.virtual_text),
        "lsp.virtual_text must be one of: " .. table.concat(valid_values, ", ")
      )
    end

    if conf.ui and conf.ui.border then
      local valid_borders = { "single", "double", "rounded", "none" }
      assert(
        vim.tbl_contains(valid_borders, conf.ui.border),
        "ui.border must be one of: " .. table.concat(valid_borders, ", ")
      )
    end
  end)

  if not ok then
    vim.notify("Configuration validation failed: " .. err, vim.log.levels.ERROR)
    return false
  end

  return true
end

-- Setup configuration with user overrides
function M.setup(opts)
  opts = opts or {}

  -- Merge with defaults
  config = deep_merge(defaults, opts)

  -- Validate configuration
  if not validate(config) then
    -- Fall back to defaults on validation failure
    config = vim.deepcopy(defaults)
  end

  -- Create paths if they don't exist
  for name, path in pairs(config.paths) do
    vim.fn.mkdir(path, "p")
  end

  -- Notify watchers of configuration change
  M.notify_change()
end

-- Get configuration value by dot-notation path
function M.get(path, default_value)
  if not path then
    return vim.deepcopy(config)
  end

  local keys = vim.split(path, ".", { plain = true })
  local value = config

  for _, key in ipairs(keys) do
    if type(value) ~= "table" then
      return default_value
    end
    value = value[key]
    if value == nil then
      return default_value
    end
  end

  -- Return a copy for tables to prevent accidental mutations
  if type(value) == "table" then
    return vim.deepcopy(value)
  end

  return value
end

-- Set configuration value by dot-notation path
function M.set(path, value)
  local keys = vim.split(path, ".", { plain = true })
  local target = config

  -- Navigate to parent
  for i = 1, #keys - 1 do
    local key = keys[i]
    if type(target[key]) ~= "table" then
      target[key] = {}
    end
    target = target[key]
  end

  -- Set the value
  local last_key = keys[#keys]
  local old_value = target[last_key]
  target[last_key] = value

  -- Notify watchers if value changed
  if old_value ~= value then
    M.notify_change(path, old_value, value)
  end
end

-- Check if a feature is enabled
function M.is_enabled(feature)
  return config.features and config.features[feature] == true
end

-- Toggle a feature
function M.toggle(feature)
  if config.features and config.features[feature] ~= nil then
    local new_value = not config.features[feature]
    M.set("features." .. feature, new_value)
    vim.notify(
      string.format("Feature '%s' %s", feature, new_value and "enabled" or "disabled"),
      vim.log.levels.INFO
    )
    return new_value
  end
  return false
end

-- Watch for configuration changes
function M.watch(path, callback)
  if type(callback) ~= "function" then
    error("Callback must be a function")
  end

  watchers[path] = watchers[path] or {}
  table.insert(watchers[path], callback)

  -- Return unwatch function
  return function()
    if watchers[path] then
      for i, cb in ipairs(watchers[path]) do
        if cb == callback then
          table.remove(watchers[path], i)
          break
        end
      end
    end
  end
end

-- Notify watchers of configuration changes
function M.notify_change(path, old_value, new_value)
  -- Notify specific path watchers
  if path and watchers[path] then
    for _, callback in ipairs(watchers[path]) do
      pcall(callback, new_value, old_value, path)
    end
  end

  -- Notify global watchers
  if watchers["*"] then
    for _, callback in ipairs(watchers["*"]) do
      pcall(callback, config, path)
    end
  end

  -- Emit autocmd for configuration change
  vim.api.nvim_exec_autocmds("User", {
    pattern = "MarvimConfigChanged",
    data = { path = path, old_value = old_value, new_value = new_value },
  })
end

-- Export configuration for debugging
function M.dump()
  return vim.inspect(config)
end

-- Reset to defaults
function M.reset()
  config = vim.deepcopy(defaults)
  M.notify_change()
end

return M