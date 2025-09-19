-- MARVIM Framework Health Check Module
-- Provides comprehensive diagnostics for framework status

local M = {}

-- Cache for health check results
local health_cache = {}
local last_check_time = 0
local CACHE_DURATION = 5000 -- 5 seconds

-- Framework modules to check
local FRAMEWORK_MODULES = {
  "marvim.init",
  "marvim.config",
  "marvim.module",
  "marvim.utils",
  "marvim.autocmd",
  "marvim.toggle",
  "marvim.event",
  "marvim.plugin",
  "marvim.cache",
  "marvim.migrate"
}

-- Check if a module is loaded
local function check_module(name)
  local ok, mod = pcall(require, name)
  if not ok then
    return false, "Failed to load: " .. tostring(mod)
  end
  return true, mod
end

-- Get memory usage in MB
local function get_memory_usage()
  if vim.fn.has("nvim-0.9") == 0 then
    return "N/A (requires Neovim 0.9+)"
  end
  local mem = vim.fn.luaeval("collectgarbage('count')")
  return string.format("%.2f MB", mem / 1024)
end

-- Check framework initialization
function M.check_framework()
  local results = {
    modules = {},
    status = "healthy",
    warnings = {},
    errors = {}
  }

  -- Check core modules
  for _, mod_name in ipairs(FRAMEWORK_MODULES) do
    local ok, mod = check_module(mod_name)
    results.modules[mod_name] = {
      loaded = ok,
      error = not ok and mod or nil
    }
    if not ok then
      results.status = "error"
      table.insert(results.errors, mod_name .. ": " .. tostring(mod))
    end
  end

  -- Check global namespace
  if not _G.Marvim then
    results.status = "error"
    table.insert(results.errors, "Global Marvim namespace not initialized")
  else
    results.namespace = {
      config = _G.Marvim.config ~= nil,
      modules = _G.Marvim.modules ~= nil,
      cache = _G.Marvim.cache ~= nil,
      events = _G.Marvim.events ~= nil,
      toggles = _G.Marvim.toggles ~= nil
    }
  end

  return results
end

-- Check cache performance
function M.check_cache()
  local cache = require("marvim.cache")
  local stats = cache.stats()

  return {
    enabled = true,
    size = stats.size or 0,
    hits = stats.hits or 0,
    misses = stats.misses or 0,
    hit_rate = stats.hits and stats.misses and
               (stats.hits > 0 and string.format("%.1f%%", (stats.hits / (stats.hits + stats.misses)) * 100) or "0%") or "N/A",
    evictions = stats.evictions or 0
  }
end

-- Check event system
function M.check_events()
  local event = require("marvim.event")
  local listeners = event.get_listeners()

  local event_stats = {}
  for name, handlers in pairs(listeners) do
    event_stats[name] = #handlers
  end

  return {
    enabled = true,
    total_events = vim.tbl_count(listeners),
    total_listeners = vim.tbl_count(vim.tbl_flatten(listeners)),
    events = event_stats
  }
end

-- Check toggle system
function M.check_toggles()
  local toggle = require("marvim.toggle")
  local toggles = toggle.list()

  local toggle_states = {}
  for _, name in ipairs(toggles) do
    local state = toggle.state(name)
    toggle_states[name] = state ~= nil and state or "unknown"
  end

  return {
    enabled = true,
    total = #toggles,
    states = toggle_states
  }
end

-- Check autocmd system
function M.check_autocmds()
  local autocmd = require("marvim.autocmd")
  local groups = autocmd.list_groups()

  local group_stats = {}
  for _, group in ipairs(groups) do
    local cmds = vim.api.nvim_get_autocmds({ group = group })
    group_stats[group] = #cmds
  end

  return {
    enabled = true,
    total_groups = #groups,
    total_commands = vim.tbl_count(vim.tbl_flatten(vim.tbl_values(group_stats))),
    groups = group_stats
  }
end

-- Check migration status
function M.check_migration()
  local migrate = require("marvim.migrate")
  local warnings = migrate.get_warnings()
  local deprecated = migrate.get_deprecated()

  return {
    warnings = #warnings,
    deprecated = #deprecated,
    warning_list = warnings,
    deprecated_list = deprecated,
    status = #warnings == 0 and #deprecated == 0 and "complete" or "in_progress"
  }
end

-- Check performance metrics
function M.check_performance()
  local startuptime = vim.fn.exists("g:marvim_startuptime") == 1 and vim.g.marvim_startuptime or nil

  return {
    memory_usage = get_memory_usage(),
    startup_time = startuptime and string.format("%.2f ms", startuptime) or "Not measured",
    lua_modules = vim.tbl_count(package.loaded),
    lazy_loaded = vim.fn.exists(":Lazy") == 2 and "Yes" or "No"
  }
end

-- Format health check results
local function format_results(results)
  local lines = {}
  local indent = "  "

  -- Title
  table.insert(lines, "MARVIM Framework Health Check")
  table.insert(lines, string.rep("=", 50))
  table.insert(lines, "")

  -- Framework Status
  local status_icon = results.framework.status == "healthy" and "✓" or "✗"
  local status_color = results.framework.status == "healthy" and "green" or "red"
  table.insert(lines, string.format("Framework Status: %s %s", status_icon, results.framework.status:upper()))
  table.insert(lines, "")

  -- Module Status
  table.insert(lines, "Modules:")
  for mod, info in pairs(results.framework.modules) do
    local icon = info.loaded and "✓" or "✗"
    local status = info.loaded and "loaded" or "ERROR"
    table.insert(lines, string.format("%s%s %s - %s", indent, icon, mod, status))
    if info.error then
      table.insert(lines, string.format("%s  Error: %s", indent, info.error))
    end
  end
  table.insert(lines, "")

  -- Cache Performance
  table.insert(lines, "Cache Performance:")
  table.insert(lines, string.format("%sSize: %d items", indent, results.cache.size))
  table.insert(lines, string.format("%sHits: %d", indent, results.cache.hits))
  table.insert(lines, string.format("%sMisses: %d", indent, results.cache.misses))
  table.insert(lines, string.format("%sHit Rate: %s", indent, results.cache.hit_rate))
  table.insert(lines, string.format("%sEvictions: %d", indent, results.cache.evictions))
  table.insert(lines, "")

  -- Event System
  table.insert(lines, "Event System:")
  table.insert(lines, string.format("%sTotal Events: %d", indent, results.events.total_events))
  table.insert(lines, string.format("%sTotal Listeners: %d", indent, results.events.total_listeners))
  if vim.tbl_count(results.events.events) > 0 then
    table.insert(lines, indent .. "Events:")
    for name, count in pairs(results.events.events) do
      table.insert(lines, string.format("%s  %s: %d listeners", indent, name, count))
    end
  end
  table.insert(lines, "")

  -- Toggle System
  table.insert(lines, "Toggle System:")
  table.insert(lines, string.format("%sTotal Toggles: %d", indent, results.toggles.total))
  if vim.tbl_count(results.toggles.states) > 0 then
    table.insert(lines, indent .. "States:")
    for name, state in pairs(results.toggles.states) do
      local state_str = state == true and "ON" or state == false and "OFF" or "UNKNOWN"
      table.insert(lines, string.format("%s  %s: %s", indent, name, state_str))
    end
  end
  table.insert(lines, "")

  -- Autocmd System
  table.insert(lines, "Autocmd System:")
  table.insert(lines, string.format("%sTotal Groups: %d", indent, results.autocmds.total_groups))
  table.insert(lines, string.format("%sTotal Commands: %d", indent, results.autocmds.total_commands))
  if vim.tbl_count(results.autocmds.groups) > 0 then
    table.insert(lines, indent .. "Groups:")
    for group, count in pairs(results.autocmds.groups) do
      table.insert(lines, string.format("%s  %s: %d commands", indent, group, count))
    end
  end
  table.insert(lines, "")

  -- Migration Status
  table.insert(lines, "Migration Status:")
  table.insert(lines, string.format("%sStatus: %s", indent, results.migration.status:upper()))
  table.insert(lines, string.format("%sWarnings: %d", indent, results.migration.warnings))
  table.insert(lines, string.format("%sDeprecated: %d", indent, results.migration.deprecated))
  if #results.migration.warning_list > 0 then
    table.insert(lines, indent .. "Warnings:")
    for _, warning in ipairs(results.migration.warning_list) do
      table.insert(lines, string.format("%s  - %s", indent, warning))
    end
  end
  if #results.migration.deprecated_list > 0 then
    table.insert(lines, indent .. "Deprecated:")
    for _, deprecated in ipairs(results.migration.deprecated_list) do
      table.insert(lines, string.format("%s  - %s", indent, deprecated))
    end
  end
  table.insert(lines, "")

  -- Performance Metrics
  table.insert(lines, "Performance Metrics:")
  table.insert(lines, string.format("%sMemory Usage: %s", indent, results.performance.memory_usage))
  table.insert(lines, string.format("%sStartup Time: %s", indent, results.performance.startup_time))
  table.insert(lines, string.format("%sLoaded Lua Modules: %d", indent, results.performance.lua_modules))
  table.insert(lines, string.format("%sLazy Loading: %s", indent, results.performance.lazy_loaded))
  table.insert(lines, "")

  -- Recommendations
  if #results.framework.errors > 0 or
     results.migration.warnings > 0 or
     results.migration.deprecated > 0 then
    table.insert(lines, "Recommendations:")

    if #results.framework.errors > 0 then
      table.insert(lines, indent .. "• Fix module loading errors above")
    end

    if results.migration.warnings > 0 then
      table.insert(lines, indent .. "• Address migration warnings")
    end

    if results.migration.deprecated > 0 then
      table.insert(lines, indent .. "• Update deprecated API usage")
    end

    if results.cache.hit_rate and tonumber(results.cache.hit_rate:match("(%d+%.?%d*)")) < 80 then
      table.insert(lines, indent .. "• Cache hit rate is low, consider profiling module loading")
    end

    table.insert(lines, "")
  end

  return table.concat(lines, "\n")
end

-- Run comprehensive health check
function M.run()
  local now = vim.loop.now()

  -- Use cache if recent
  if now - last_check_time < CACHE_DURATION and vim.tbl_count(health_cache) > 0 then
    return health_cache
  end

  -- Run all checks
  local results = {
    framework = M.check_framework(),
    cache = M.check_cache(),
    events = M.check_events(),
    toggles = M.check_toggles(),
    autocmds = M.check_autocmds(),
    migration = M.check_migration(),
    performance = M.check_performance()
  }

  -- Cache results
  health_cache = results
  last_check_time = now

  return results
end

-- Display health check in a buffer
function M.show()
  local results = M.run()
  local content = format_results(results)

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "marvimhealth")
  vim.api.nvim_buf_set_name(buf, "MARVIM Health")

  -- Set content
  local lines = vim.split(content, "\n")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Make it read-only
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Open in a split
  vim.cmd("split")
  vim.api.nvim_win_set_buf(0, buf)

  -- Add keymaps
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "r", ":lua require('marvim.health').refresh()<CR>",
                              { noremap = true, silent = true, desc = "Refresh health check" })

  -- Add syntax highlighting
  vim.cmd([[
    syntax match MarvimHealthSuccess /✓/
    syntax match MarvimHealthError /✗/
    syntax match MarvimHealthTitle /^MARVIM Framework Health Check$/
    syntax match MarvimHealthSection /^\w\+.*:$/
    syntax match MarvimHealthWarning /Warning.*/
    syntax match MarvimHealthDeprecated /Deprecated.*/

    highlight MarvimHealthSuccess guifg=#a6e3a1
    highlight MarvimHealthError guifg=#f38ba8
    highlight MarvimHealthTitle gui=bold guifg=#89b4fa
    highlight MarvimHealthSection gui=bold guifg=#cba6f7
    highlight MarvimHealthWarning guifg=#f9e2af
    highlight MarvimHealthDeprecated guifg=#fab387
  ]])
end

-- Refresh current health buffer
function M.refresh()
  -- Clear cache
  health_cache = {}
  last_check_time = 0

  -- Re-run if in health buffer
  if vim.bo.filetype == "marvimhealth" then
    local buf = vim.api.nvim_get_current_buf()
    local results = M.run()
    local content = format_results(results)
    local lines = vim.split(content, "\n")

    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
  else
    M.show()
  end
end

-- Integration with vim.health (for :checkhealth)
function M.check()
  local health = vim.health or require("health")
  local results = M.run()

  health.start("MARVIM Framework")

  -- Check framework status
  if results.framework.status == "healthy" then
    health.ok("Framework initialized successfully")
  else
    health.error("Framework initialization failed", results.framework.errors)
  end

  -- Check modules
  for mod, info in pairs(results.framework.modules) do
    if info.loaded then
      health.ok(mod .. " loaded")
    else
      health.error(mod .. " failed to load", { info.error })
    end
  end

  -- Check cache performance
  if results.cache.hit_rate and tonumber(results.cache.hit_rate:match("(%d+%.?%d*)")) >= 80 then
    health.ok("Cache hit rate: " .. results.cache.hit_rate)
  else
    health.warn("Low cache hit rate: " .. results.cache.hit_rate)
  end

  -- Check migration
  if results.migration.status == "complete" then
    health.ok("Migration complete")
  else
    health.warn("Migration in progress", {
      "Warnings: " .. results.migration.warnings,
      "Deprecated: " .. results.migration.deprecated
    })
  end

  -- Performance
  health.info("Memory usage: " .. results.performance.memory_usage)
  health.info("Startup time: " .. results.performance.startup_time)
  health.info("Loaded modules: " .. results.performance.lua_modules)
end

return M