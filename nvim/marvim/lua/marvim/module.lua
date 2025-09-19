-- MARVIM Module System
-- Safe module loading with caching, error handling, and deferred loading

local M = {}

-- Module cache for loaded modules
local cache = {}

-- Pending deferred loads
local deferred = {}

-- Module load statistics for debugging
local stats = {
  loads = 0,
  cache_hits = 0,
  failures = 0,
  deferred_count = 0,
}

-- Error handler for module loading
local function handle_error(module_name, err)
  stats.failures = stats.failures + 1

  local msg = string.format("Failed to load module '%s': %s", module_name, err)

  -- Log to file for debugging
  local log_file = vim.fn.stdpath("cache") .. "/marvim_module_errors.log"
  local file = io.open(log_file, "a")
  if file then
    file:write(string.format("[%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), msg))
    file:close()
  end

  -- Only show error in debug mode or for critical modules
  if vim.g.marvim_debug or module_name:match("^marvim%.") then
    vim.notify(msg, vim.log.levels.ERROR)
  end

  return nil
end

-- Load a module safely with caching
function M.load(module_name, opts)
  opts = opts or {}

  -- Check cache first
  if cache[module_name] ~= nil and not opts.force then
    stats.cache_hits = stats.cache_hits + 1
    return cache[module_name]
  end

  stats.loads = stats.loads + 1

  -- Try to load the module
  local ok, result = pcall(require, module_name)

  if ok then
    -- Cache successful load (even if result is false/nil)
    cache[module_name] = result

    -- Process any pending deferred loads for this module
    if deferred[module_name] then
      for _, callback in ipairs(deferred[module_name]) do
        pcall(callback, result)
      end
      deferred[module_name] = nil
      stats.deferred_count = stats.deferred_count - #deferred[module_name]
    end

    return result
  else
    -- Handle error
    if not opts.silent then
      handle_error(module_name, result)
    end

    -- Cache failure to avoid repeated attempts
    if opts.cache_failures then
      cache[module_name] = false
    end

    return opts.default
  end
end

-- Try to load a module, return success status and module
function M.try_load(module_name, opts)
  opts = opts or {}
  opts.silent = true

  local module = M.load(module_name, opts)
  return module ~= nil and module ~= false, module
end

-- Load a module when it becomes available
function M.on_load(module_name, callback)
  if type(callback) ~= "function" then
    error("Callback must be a function")
  end

  -- Check if module is already loaded
  if cache[module_name] and cache[module_name] ~= false then
    callback(cache[module_name])
    return
  end

  -- Try to load it now
  local ok, module = M.try_load(module_name)
  if ok then
    callback(module)
    return
  end

  -- Queue for deferred loading
  deferred[module_name] = deferred[module_name] or {}
  table.insert(deferred[module_name], callback)
  stats.deferred_count = stats.deferred_count + 1

  -- Set up autocmd to check on VimEnter if not already loaded
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      vim.schedule(function()
        M.process_deferred()
      end)
    end,
  })
end

-- Process all deferred module loads
function M.process_deferred()
  for module_name, callbacks in pairs(deferred) do
    local ok, module = M.try_load(module_name)
    if ok then
      for _, callback in ipairs(callbacks) do
        pcall(callback, module)
      end
      deferred[module_name] = nil
      stats.deferred_count = stats.deferred_count - #callbacks
    end
  end
end

-- Safely call a function from a module
function M.call(module_name, fn_name, ...)
  local module = M.load(module_name, { silent = true })

  if not module then
    return nil
  end

  if type(module[fn_name]) ~= "function" then
    if not vim.g.marvim_silent then
      vim.notify(
        string.format("Function '%s' not found in module '%s'", fn_name, module_name),
        vim.log.levels.WARN
      )
    end
    return nil
  end

  local ok, result = pcall(module[fn_name], ...)
  if ok then
    return result
  else
    handle_error(module_name .. "." .. fn_name, result)
    return nil
  end
end

-- Protected module setup - load and call setup if available
function M.setup(module_name, opts)
  local module = M.load(module_name)

  if not module then
    return false
  end

  if type(module.setup) == "function" then
    local ok, err = pcall(module.setup, opts)
    if not ok then
      handle_error(module_name .. ".setup", err)
      return false
    end
  end

  return true
end

-- Batch load multiple modules
function M.load_all(module_list, opts)
  opts = opts or {}
  local loaded = {}
  local failed = {}

  for _, module_name in ipairs(module_list) do
    local module = M.load(module_name, { silent = opts.silent })
    if module and module ~= false then
      loaded[module_name] = module
    else
      table.insert(failed, module_name)
    end
  end

  if #failed > 0 and not opts.silent then
    vim.notify(
      string.format("Failed to load modules: %s", table.concat(failed, ", ")),
      vim.log.levels.WARN
    )
  end

  return loaded, failed
end

-- Clear module cache
function M.clear_cache(module_name)
  if module_name then
    cache[module_name] = nil
    -- Also clear from package.loaded for full reload
    package.loaded[module_name] = nil
  else
    cache = {}
  end
end

-- Reload a module
function M.reload(module_name)
  M.clear_cache(module_name)
  return M.load(module_name, { force = true })
end

-- Check if a module exists without loading it
function M.exists(module_name)
  -- Check cache first
  if cache[module_name] ~= nil then
    return cache[module_name] ~= false
  end

  -- Try to find the module file
  local ok = pcall(require, module_name)
  return ok
end

-- Get module loading statistics
function M.stats()
  return vim.deepcopy(stats)
end

-- Reset statistics
function M.reset_stats()
  stats = {
    loads = 0,
    cache_hits = 0,
    failures = 0,
    deferred_count = 0,
  }
end

-- Debug function to inspect module state
function M.debug()
  local info = {
    stats = M.stats(),
    cached_modules = vim.tbl_keys(cache),
    deferred_modules = vim.tbl_keys(deferred),
    cache_size = vim.tbl_count(cache),
  }
  return info
end

return M