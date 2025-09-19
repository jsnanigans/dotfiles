-- MARVIM Toggle System
-- Provides a centralized system for toggling features with persistence

local M = {}

-- Store toggle definitions
local toggles = {}

-- Store current states (will sync with config for persistence)
local states = {}

-- Toggle definition structure:
-- {
--   on = function() ... end,      -- Enable the feature
--   off = function() ... end,     -- Disable the feature
--   status = function() ... end,  -- Get current status (optional, defaults to state tracking)
--   default = boolean,            -- Default state (optional, defaults to false)
--   description = string,         -- Description for documentation (optional)
-- }

-- Register a new toggle
function M.register(name, definition)
  if type(name) ~= "string" or name == "" then
    error("Toggle name must be a non-empty string")
  end

  if type(definition) ~= "table" then
    error("Toggle definition must be a table")
  end

  if type(definition.on) ~= "function" then
    error("Toggle definition must have an 'on' function")
  end

  if type(definition.off) ~= "function" then
    error("Toggle definition must have an 'off' function")
  end

  -- Optional status function, defaults to internal state tracking
  if definition.status and type(definition.status) ~= "function" then
    error("Toggle status must be a function if provided")
  end

  toggles[name] = definition

  -- Initialize state from config or default
  local config = require("marvim.config")
  local config_key = "toggles." .. name
  local stored_state = config.get(config_key)

  if stored_state ~= nil then
    states[name] = stored_state
  else
    states[name] = definition.default or false
    -- Store initial state in config
    config.set(config_key, states[name])
  end

  -- Apply initial state
  if states[name] then
    M.enable(name)
  else
    M.disable(name)
  end
end

-- Enable a toggle
function M.enable(name)
  local toggle = toggles[name]
  if not toggle then
    vim.notify("Toggle '" .. name .. "' not registered", vim.log.levels.WARN)
    return false
  end

  local ok, err = pcall(toggle.on)
  if not ok then
    vim.notify("Failed to enable toggle '" .. name .. "': " .. tostring(err), vim.log.levels.ERROR)
    return false
  end

  states[name] = true

  -- Persist to config
  local config = require("marvim.config")
  config.set("toggles." .. name, true)

  -- Emit event
  local events = require("marvim.event")
  if events then
    events.emit("ToggleChanged", name, true)
  end

  return true
end

-- Disable a toggle
function M.disable(name)
  local toggle = toggles[name]
  if not toggle then
    vim.notify("Toggle '" .. name .. "' not registered", vim.log.levels.WARN)
    return false
  end

  local ok, err = pcall(toggle.off)
  if not ok then
    vim.notify("Failed to disable toggle '" .. name .. "': " .. tostring(err), vim.log.levels.ERROR)
    return false
  end

  states[name] = false

  -- Persist to config
  local config = require("marvim.config")
  config.set("toggles." .. name, false)

  -- Emit event
  local events = require("marvim.event")
  if events then
    events.emit("ToggleChanged", name, false)
  end

  return true
end

-- Toggle a feature (switch between on/off)
function M.toggle(name)
  if M.is_enabled(name) then
    return M.disable(name)
  else
    return M.enable(name)
  end
end

-- Check if a toggle is enabled
function M.is_enabled(name)
  local toggle = toggles[name]
  if not toggle then
    return false
  end

  -- Use custom status function if provided
  if toggle.status then
    local ok, result = pcall(toggle.status)
    if ok then
      return result == true
    end
  end

  -- Fall back to internal state
  return states[name] == true
end

-- Get toggle state (alias for is_enabled, for health check compatibility)
function M.state(name)
  return M.is_enabled(name)
end

-- Get all registered toggles (returns just names for health check)
function M.list()
  local names = vim.tbl_keys(toggles)
  table.sort(names)
  return names
end

-- Get detailed list of all toggles with status
function M.list_detailed()
  local list = {}
  for name, def in pairs(toggles) do
    table.insert(list, {
      name = name,
      enabled = M.is_enabled(name),
      description = def.description or "No description",
      has_custom_status = def.status ~= nil,
    })
  end
  table.sort(list, function(a, b) return a.name < b.name end)
  return list
end

-- Get a specific toggle definition
function M.get(name)
  return toggles[name]
end

-- Remove a toggle (for cleanup/testing)
function M.unregister(name)
  toggles[name] = nil
  states[name] = nil

  -- Remove from config
  local config = require("marvim.config")
  config.set("toggles." .. name, nil)
end

-- Setup common toggles
function M.setup_common()
  -- Diagnostics toggle
  M.register("diagnostics", {
    on = function() vim.diagnostic.enable() end,
    off = function() vim.diagnostic.disable() end,
    status = function() return vim.diagnostic.is_enabled() end,
    default = true,
    description = "LSP diagnostics",
  })

  -- Format on save toggle
  M.register("format_on_save", {
    on = function()
      vim.g.format_on_save = true
      -- Could also setup autocmd here if needed
    end,
    off = function()
      vim.g.format_on_save = false
    end,
    status = function()
      return vim.g.format_on_save == true
    end,
    default = true,
    description = "Auto-format on save",
  })

  -- Inlay hints toggle
  M.register("inlay_hints", {
    on = function()
      if vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(true)
      end
    end,
    off = function()
      if vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(false)
      end
    end,
    status = function()
      if vim.lsp.inlay_hint then
        return vim.lsp.inlay_hint.is_enabled()
      end
      return false
    end,
    default = false,
    description = "LSP inlay hints",
  })

  -- Relative line numbers toggle
  M.register("relative_numbers", {
    on = function() vim.opt.relativenumber = true end,
    off = function() vim.opt.relativenumber = false end,
    status = function() return vim.opt.relativenumber:get() end,
    default = true,
    description = "Relative line numbers",
  })

  -- Spell checking toggle
  M.register("spell", {
    on = function() vim.opt.spell = true end,
    off = function() vim.opt.spell = false end,
    status = function() return vim.opt.spell:get() end,
    default = false,
    description = "Spell checking",
  })

  -- Wrap toggle
  M.register("wrap", {
    on = function() vim.opt.wrap = true end,
    off = function() vim.opt.wrap = false end,
    status = function() return vim.opt.wrap:get() end,
    default = false,
    description = "Line wrapping",
  })
end

-- Debug info
function M.debug()
  return {
    toggles = vim.tbl_keys(toggles),
    states = vim.deepcopy(states),
    list = M.list(),
  }
end

-- Create user command for easy toggling
function M.setup_commands()
  vim.api.nvim_create_user_command("Toggle", function(opts)
    local name = opts.args
    if name == "" then
      -- Show all toggles
      local list = M.list()
      print("Available toggles:")
      for _, toggle in ipairs(list) do
        local status = toggle.enabled and "ON" or "OFF"
        print(string.format("  %s: %s - %s", toggle.name, status, toggle.description))
      end
    else
      -- Toggle specific feature
      if M.toggle(name) then
        local status = M.is_enabled(name) and "enabled" or "disabled"
        vim.notify("Toggle '" .. name .. "' " .. status, vim.log.levels.INFO)
      end
    end
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_keys(toggles)
    end,
    desc = "Toggle a feature",
  })
end

return M