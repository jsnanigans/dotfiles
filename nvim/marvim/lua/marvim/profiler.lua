-- MARVIM Framework Performance Profiler
-- Provides detailed performance metrics and profiling

local M = {}

-- Profiling data storage
local profiles = {}
local timers = {}
local module_load_times = {}
local event_processing_times = {}
local command_execution_times = {}

-- Profiling configuration
local config = {
  enabled = false,
  auto_profile = false,
  sample_rate = 1000, -- Sample every N calls
  max_samples = 1000,
  detailed_modules = true
}

-- High resolution timer
local function hrtime()
  return vim.loop.hrtime() / 1000000 -- Convert to milliseconds
end

-- Initialize profiler
function M.init(opts)
  config = vim.tbl_extend("force", config, opts or {})

  if config.auto_profile then
    M.start()
  end

  -- Store startup time
  if vim.g.marvim_startuptime == nil then
    vim.g.marvim_startuptime = hrtime()
  end
end

-- Start profiling
function M.start()
  config.enabled = true
  profiles = {}
  timers = {}

  -- Hook into require to track module load times
  if config.detailed_modules then
    M._hook_require()
  end

  -- Hook into event system
  M._hook_events()

  -- Mark start time
  profiles.start_time = hrtime()
  profiles.samples = 0

  vim.notify("MARVIM Profiler started", vim.log.levels.INFO)
end

-- Stop profiling
function M.stop()
  config.enabled = false

  -- Unhook require
  if M._original_require then
    _G.require = M._original_require
    M._original_require = nil
  end

  profiles.end_time = hrtime()
  profiles.total_time = profiles.end_time - profiles.start_time

  vim.notify("MARVIM Profiler stopped", vim.log.levels.INFO)
  return M.report()
end

-- Hook into require for module profiling
function M._hook_require()
  if M._original_require then
    return -- Already hooked
  end

  M._original_require = _G.require
  _G.require = function(modname)
    if not config.enabled then
      return M._original_require(modname)
    end

    local start = hrtime()
    local result = M._original_require(modname)
    local duration = hrtime() - start

    -- Track module load time
    if not module_load_times[modname] then
      module_load_times[modname] = {
        count = 0,
        total = 0,
        min = math.huge,
        max = 0,
        avg = 0
      }
    end

    local stats = module_load_times[modname]
    stats.count = stats.count + 1
    stats.total = stats.total + duration
    stats.min = math.min(stats.min, duration)
    stats.max = math.max(stats.max, duration)
    stats.avg = stats.total / stats.count

    return result
  end
end

-- Hook into event system for profiling
function M._hook_events()
  local event = require("marvim.event")

  -- Wrap emit function
  local original_emit = event.emit
  event.emit = function(name, ...)
    if not config.enabled then
      return original_emit(name, ...)
    end

    local start = hrtime()
    local result = original_emit(name, ...)
    local duration = hrtime() - start

    -- Track event processing time
    if not event_processing_times[name] then
      event_processing_times[name] = {
        count = 0,
        total = 0,
        min = math.huge,
        max = 0,
        avg = 0
      }
    end

    local stats = event_processing_times[name]
    stats.count = stats.count + 1
    stats.total = stats.total + duration
    stats.min = math.min(stats.min, duration)
    stats.max = math.max(stats.max, duration)
    stats.avg = stats.total / stats.count

    return result
  end
end

-- Profile a specific function
function M.profile(name, fn)
  return function(...)
    if not config.enabled then
      return fn(...)
    end

    local start = hrtime()
    local result = fn(...)
    local duration = hrtime() - start

    -- Track in profiles
    if not profiles[name] then
      profiles[name] = {
        count = 0,
        total = 0,
        min = math.huge,
        max = 0,
        avg = 0
      }
    end

    local stats = profiles[name]
    stats.count = stats.count + 1
    stats.total = stats.total + duration
    stats.min = math.min(stats.min, duration)
    stats.max = math.max(stats.max, duration)
    stats.avg = stats.total / stats.count

    profiles.samples = profiles.samples + 1

    return result
  end
end

-- Timer functions
function M.timer_start(name)
  timers[name] = hrtime()
end

function M.timer_end(name)
  if not timers[name] then
    return nil
  end

  local duration = hrtime() - timers[name]
  timers[name] = nil

  -- Store in profiles
  if not profiles[name] then
    profiles[name] = {
      count = 0,
      total = 0,
      min = math.huge,
      max = 0,
      avg = 0
    }
  end

  local stats = profiles[name]
  stats.count = stats.count + 1
  stats.total = stats.total + duration
  stats.min = math.min(stats.min, duration)
  stats.max = math.max(stats.max, duration)
  stats.avg = stats.total / stats.count

  return duration
end

-- Get memory stats
function M.memory_stats()
  collectgarbage("collect")
  local mem_kb = collectgarbage("count")

  return {
    used_mb = mem_kb / 1024,
    used_kb = mem_kb,
    lua_objects = collectgarbage("count") * 1024 -- Approximate object count
  }
end

-- Get module stats
function M.module_stats()
  local stats = {
    total_loaded = vim.tbl_count(package.loaded),
    marvim_modules = 0,
    plugin_modules = 0,
    core_modules = 0
  }

  for name, _ in pairs(package.loaded) do
    if name:match("^marvim%.") then
      stats.marvim_modules = stats.marvim_modules + 1
    elseif name:match("^config%.") or name:match("^utils%.") then
      stats.core_modules = stats.core_modules + 1
    elseif not name:match("^vim%.") and not name:match("^_") then
      stats.plugin_modules = stats.plugin_modules + 1
    end
  end

  return stats
end

-- Get top slow modules
function M.top_slow_modules(limit)
  limit = limit or 10
  local sorted = {}

  for name, stats in pairs(module_load_times) do
    table.insert(sorted, {
      name = name,
      total = stats.total,
      avg = stats.avg,
      count = stats.count
    })
  end

  table.sort(sorted, function(a, b)
    return a.total > b.total
  end)

  local result = {}
  for i = 1, math.min(limit, #sorted) do
    table.insert(result, sorted[i])
  end

  return result
end

-- Get top slow events
function M.top_slow_events(limit)
  limit = limit or 10
  local sorted = {}

  for name, stats in pairs(event_processing_times) do
    table.insert(sorted, {
      name = name,
      total = stats.total,
      avg = stats.avg,
      count = stats.count
    })
  end

  table.sort(sorted, function(a, b)
    return a.total > b.total
  end)

  local result = {}
  for i = 1, math.min(limit, #sorted) do
    table.insert(result, sorted[i])
  end

  return result
end

-- Generate performance report
function M.report()
  local report = {
    enabled = config.enabled,
    runtime = profiles.total_time or (hrtime() - (profiles.start_time or 0)),
    samples = profiles.samples or 0,
    memory = M.memory_stats(),
    modules = M.module_stats(),
    top_modules = M.top_slow_modules(10),
    top_events = M.top_slow_events(10),
    profiles = profiles
  }

  -- Calculate startup metrics
  if vim.g.marvim_startuptime then
    report.startup = {
      total = vim.g.marvim_startuptime,
      to_init = vim.g.marvim_init_time or 0,
      to_plugins = vim.g.marvim_plugins_time or 0,
      to_ready = vim.g.marvim_ready_time or 0
    }
  end

  -- Cache statistics
  local cache = require("marvim.cache")
  report.cache = cache.stats()

  return report
end

-- Format report for display
local function format_report(report)
  local lines = {}
  local indent = "  "

  -- Title
  table.insert(lines, "MARVIM Performance Report")
  table.insert(lines, string.rep("=", 50))
  table.insert(lines, "")

  -- Runtime Stats
  table.insert(lines, "Runtime Statistics:")
  table.insert(lines, string.format("%sProfiler Status: %s", indent, report.enabled and "Running" or "Stopped"))
  table.insert(lines, string.format("%sTotal Runtime: %.2f ms", indent, report.runtime or 0))
  table.insert(lines, string.format("%sSamples Collected: %d", indent, report.samples))
  table.insert(lines, "")

  -- Startup Metrics
  if report.startup then
    table.insert(lines, "Startup Metrics:")
    table.insert(lines, string.format("%sTotal Startup: %.2f ms", indent, report.startup.total))
    if report.startup.to_init > 0 then
      table.insert(lines, string.format("%sTo Init: %.2f ms", indent, report.startup.to_init))
    end
    if report.startup.to_plugins > 0 then
      table.insert(lines, string.format("%sTo Plugins: %.2f ms", indent, report.startup.to_plugins))
    end
    if report.startup.to_ready > 0 then
      table.insert(lines, string.format("%sTo Ready: %.2f ms", indent, report.startup.to_ready))
    end
    table.insert(lines, "")
  end

  -- Memory Stats
  table.insert(lines, "Memory Usage:")
  table.insert(lines, string.format("%sUsed: %.2f MB", indent, report.memory.used_mb))
  table.insert(lines, string.format("%sLua Objects: ~%d", indent, report.memory.lua_objects))
  table.insert(lines, "")

  -- Module Stats
  table.insert(lines, "Module Statistics:")
  table.insert(lines, string.format("%sTotal Loaded: %d", indent, report.modules.total_loaded))
  table.insert(lines, string.format("%sMARVIM Modules: %d", indent, report.modules.marvim_modules))
  table.insert(lines, string.format("%sCore Modules: %d", indent, report.modules.core_modules))
  table.insert(lines, string.format("%sPlugin Modules: %d", indent, report.modules.plugin_modules))
  table.insert(lines, "")

  -- Cache Stats
  if report.cache then
    table.insert(lines, "Cache Performance:")
    table.insert(lines, string.format("%sSize: %d items", indent, report.cache.size or 0))
    table.insert(lines, string.format("%sHits: %d", indent, report.cache.hits or 0))
    table.insert(lines, string.format("%sMisses: %d", indent, report.cache.misses or 0))
    if report.cache.hits and report.cache.misses and report.cache.hits > 0 then
      local hit_rate = (report.cache.hits / (report.cache.hits + report.cache.misses)) * 100
      table.insert(lines, string.format("%sHit Rate: %.1f%%", indent, hit_rate))
    end
    table.insert(lines, "")
  end

  -- Top Slow Modules
  if #report.top_modules > 0 then
    table.insert(lines, "Top Slow Modules (by total time):")
    for i, mod in ipairs(report.top_modules) do
      table.insert(lines, string.format("%s%d. %s", indent, i, mod.name))
      table.insert(lines, string.format("%s   Total: %.2f ms, Avg: %.2f ms, Count: %d",
                                       indent, mod.total, mod.avg, mod.count))
    end
    table.insert(lines, "")
  end

  -- Top Slow Events
  if #report.top_events > 0 then
    table.insert(lines, "Top Slow Events (by total time):")
    for i, event in ipairs(report.top_events) do
      table.insert(lines, string.format("%s%d. %s", indent, i, event.name))
      table.insert(lines, string.format("%s   Total: %.2f ms, Avg: %.2f ms, Count: %d",
                                       indent, event.total, event.avg, event.count))
    end
    table.insert(lines, "")
  end

  -- Custom Profiles
  local custom_profiles = {}
  for name, stats in pairs(report.profiles) do
    if name ~= "start_time" and name ~= "end_time" and name ~= "total_time" and name ~= "samples" then
      table.insert(custom_profiles, { name = name, stats = stats })
    end
  end

  if #custom_profiles > 0 then
    table.insert(lines, "Custom Profiles:")
    for _, profile in ipairs(custom_profiles) do
      table.insert(lines, string.format("%s%s:", indent, profile.name))
      table.insert(lines, string.format("%s  Total: %.2f ms, Avg: %.2f ms, Count: %d",
                                       indent, profile.stats.total, profile.stats.avg, profile.stats.count))
      table.insert(lines, string.format("%s  Min: %.2f ms, Max: %.2f ms",
                                       indent, profile.stats.min, profile.stats.max))
    end
    table.insert(lines, "")
  end

  -- Recommendations
  table.insert(lines, "Recommendations:")

  -- Check startup time
  if report.startup and report.startup.total > 100 then
    table.insert(lines, indent .. "• Startup time exceeds 100ms target")
  end

  -- Check cache hit rate
  if report.cache and report.cache.hits and report.cache.misses then
    local hit_rate = report.cache.hits / (report.cache.hits + report.cache.misses)
    if hit_rate < 0.8 then
      table.insert(lines, indent .. "• Cache hit rate below 80% target")
    end
  end

  -- Check memory usage
  if report.memory.used_mb > 100 then
    table.insert(lines, indent .. "• Memory usage exceeds 100MB")
  end

  -- Check slow modules
  if #report.top_modules > 0 and report.top_modules[1].total > 10 then
    table.insert(lines, indent .. "• Some modules taking >10ms to load")
  end

  table.insert(lines, "")

  return table.concat(lines, "\n")
end

-- Show performance report in buffer
function M.show()
  local report = M.report()
  local content = format_report(report)

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "marvimprofile")
  vim.api.nvim_buf_set_name(buf, "MARVIM Profile")

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
  vim.api.nvim_buf_set_keymap(buf, "n", "r", ":lua require('marvim.profiler').refresh()<CR>",
                              { noremap = true, silent = true, desc = "Refresh profile" })
  vim.api.nvim_buf_set_keymap(buf, "n", "s", ":lua require('marvim.profiler').start()<CR>",
                              { noremap = true, silent = true, desc = "Start profiling" })
  vim.api.nvim_buf_set_keymap(buf, "n", "S", ":lua require('marvim.profiler').stop()<CR>",
                              { noremap = true, silent = true, desc = "Stop profiling" })

  -- Add syntax highlighting
  vim.cmd([[
    syntax match MarvimProfileTitle /^MARVIM Performance Report$/
    syntax match MarvimProfileSection /^\w\+.*:$/
    syntax match MarvimProfileNumber /\d\+\.\d\+\s*ms\?/
    syntax match MarvimProfilePercent /\d\+\.\d\+%/
    syntax match MarvimProfileWarning /•.*exceeds.*/

    highlight MarvimProfileTitle gui=bold guifg=#89b4fa
    highlight MarvimProfileSection gui=bold guifg=#cba6f7
    highlight MarvimProfileNumber guifg=#a6e3a1
    highlight MarvimProfilePercent guifg=#94e2d5
    highlight MarvimProfileWarning guifg=#f9e2af
  ]])
end

-- Refresh current profile buffer
function M.refresh()
  if vim.bo.filetype == "marvimprofile" then
    local buf = vim.api.nvim_get_current_buf()
    local report = M.report()
    local content = format_report(report)
    local lines = vim.split(content, "\n")

    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
  else
    M.show()
  end
end

-- Benchmark a function
function M.benchmark(name, fn, iterations)
  iterations = iterations or 1000
  local times = {}

  for i = 1, iterations do
    local start = hrtime()
    fn()
    times[i] = hrtime() - start
  end

  -- Calculate statistics
  table.sort(times)
  local total = 0
  for _, time in ipairs(times) do
    total = total + time
  end

  local avg = total / iterations
  local median = times[math.floor(iterations / 2)]
  local min = times[1]
  local max = times[iterations]
  local p95 = times[math.floor(iterations * 0.95)]
  local p99 = times[math.floor(iterations * 0.99)]

  return {
    name = name,
    iterations = iterations,
    total = total,
    avg = avg,
    median = median,
    min = min,
    max = max,
    p95 = p95,
    p99 = p99
  }
end

return M