-- MARVIM Cache Layer
-- Performance optimization through intelligent caching with TTL and LRU eviction

local M = {}

-- Cache storage
local caches = {}

-- Global cache statistics
local stats = {
  hits = 0,
  misses = 0,
  evictions = 0,
  invalidations = 0,
}

-- Default cache configuration
local default_config = {
  max_size = 100,        -- Maximum number of entries
  ttl = 300,            -- Time to live in seconds (5 minutes)
  lru = true,           -- Use LRU eviction
  persist = false,      -- Persist cache to disk
}

-- Cache entry structure
-- {
--   value = any,
--   timestamp = number,
--   ttl = number,
--   access_count = number,
--   last_access = number,
-- }

-- Create a new cache
function M.create(name, config)
  config = vim.tbl_deep_extend("force", default_config, config or {})

  caches[name] = {
    name = name,
    config = config,
    entries = {},
    access_order = {}, -- For LRU tracking
    stats = {
      hits = 0,
      misses = 0,
      evictions = 0,
      invalidations = 0,
    },
  }

  -- Load from persistence if enabled
  if config.persist then
    M._load_cache(name)
  end

  return caches[name]
end

-- Get a value from cache
function M.get(cache_name, key)
  local cache = caches[cache_name]
  if not cache then
    return nil, "Cache not found"
  end

  local entry = cache.entries[key]
  if not entry then
    -- Cache miss
    cache.stats.misses = cache.stats.misses + 1
    stats.misses = stats.misses + 1
    return nil, "miss"
  end

  -- Check TTL
  if entry.ttl and entry.ttl > 0 then
    local age = os.time() - entry.timestamp
    if age > entry.ttl then
      -- Expired entry
      cache.entries[key] = nil
      M._remove_from_lru(cache, key)
      cache.stats.misses = cache.stats.misses + 1
      stats.misses = stats.misses + 1
      return nil, "expired"
    end
  end

  -- Cache hit
  entry.access_count = entry.access_count + 1
  entry.last_access = os.time()

  -- Update LRU order
  if cache.config.lru then
    M._update_lru(cache, key)
  end

  cache.stats.hits = cache.stats.hits + 1
  stats.hits = stats.hits + 1

  return entry.value, "hit"
end

-- Set a value in cache
function M.set(cache_name, key, value, ttl)
  local cache = caches[cache_name]
  if not cache then
    error("Cache '" .. cache_name .. "' not found")
  end

  -- Check if we need to evict
  if not cache.entries[key] and vim.tbl_count(cache.entries) >= cache.config.max_size then
    M._evict(cache)
  end

  -- Create entry
  cache.entries[key] = {
    value = value,
    timestamp = os.time(),
    ttl = ttl or cache.config.ttl,
    access_count = 0,
    last_access = os.time(),
  }

  -- Update LRU
  if cache.config.lru then
    M._update_lru(cache, key)
  end

  -- Persist if enabled
  if cache.config.persist then
    M._save_cache(cache_name)
  end

  return true
end

-- Set multiple values at once
function M.set_many(cache_name, entries, ttl)
  local cache = caches[cache_name]
  if not cache then
    error("Cache '" .. cache_name .. "' not found")
  end

  for key, value in pairs(entries) do
    M.set(cache_name, key, value, ttl)
  end
end

-- Invalidate a cache entry
function M.invalidate(cache_name, key)
  local cache = caches[cache_name]
  if not cache then
    return false
  end

  if cache.entries[key] then
    cache.entries[key] = nil
    M._remove_from_lru(cache, key)
    cache.stats.invalidations = cache.stats.invalidations + 1
    stats.invalidations = stats.invalidations + 1

    if cache.config.persist then
      M._save_cache(cache_name)
    end

    return true
  end

  return false
end

-- Invalidate entries matching a pattern
function M.invalidate_pattern(cache_name, pattern)
  local cache = caches[cache_name]
  if not cache then
    return 0
  end

  local count = 0
  for key in pairs(cache.entries) do
    if string.match(key, pattern) then
      M.invalidate(cache_name, key)
      count = count + 1
    end
  end

  return count
end

-- Clear entire cache
function M.clear(cache_name)
  local cache = caches[cache_name]
  if not cache then
    return false
  end

  local count = vim.tbl_count(cache.entries)
  cache.entries = {}
  cache.access_order = {}
  cache.stats.invalidations = cache.stats.invalidations + count
  stats.invalidations = stats.invalidations + count

  if cache.config.persist then
    M._save_cache(cache_name)
  end

  return true
end

-- Clear all caches
function M.clear_all()
  for name in pairs(caches) do
    M.clear(name)
  end
end

-- Get or compute a value (memoization pattern)
function M.get_or_set(cache_name, key, compute_fn, ttl)
  local value, status = M.get(cache_name, key)

  if status == "hit" then
    return value
  end

  -- Compute the value
  local ok, result = pcall(compute_fn)
  if not ok then
    error("Cache computation failed: " .. result)
  end

  -- Store in cache
  M.set(cache_name, key, result, ttl)
  return result
end

-- Wrap a function with caching
function M.wrap(cache_name, fn, key_fn, ttl)
  return function(...)
    local args = { ... }
    local key = key_fn and key_fn(unpack(args)) or vim.inspect(args)
    return M.get_or_set(cache_name, key, function()
      return fn(unpack(args))
    end, ttl)
  end
end

-- LRU eviction
function M._evict(cache)
  if cache.config.lru and #cache.access_order > 0 then
    -- Evict least recently used
    local lru_key = table.remove(cache.access_order, 1)
    cache.entries[lru_key] = nil
    cache.stats.evictions = cache.stats.evictions + 1
    stats.evictions = stats.evictions + 1
  else
    -- Random eviction as fallback
    for key in pairs(cache.entries) do
      cache.entries[key] = nil
      cache.stats.evictions = cache.stats.evictions + 1
      stats.evictions = stats.evictions + 1
      break
    end
  end
end

-- Update LRU order
function M._update_lru(cache, key)
  M._remove_from_lru(cache, key)
  table.insert(cache.access_order, key)
end

-- Remove from LRU order
function M._remove_from_lru(cache, key)
  for i, k in ipairs(cache.access_order) do
    if k == key then
      table.remove(cache.access_order, i)
      break
    end
  end
end

-- Get cache statistics
function M.get_stats(cache_name)
  if cache_name then
    local cache = caches[cache_name]
    if cache then
      return {
        name = cache_name,
        size = vim.tbl_count(cache.entries),
        max_size = cache.config.max_size,
        hits = cache.stats.hits,
        misses = cache.stats.misses,
        hit_rate = cache.stats.hits / math.max(1, cache.stats.hits + cache.stats.misses),
        evictions = cache.stats.evictions,
        invalidations = cache.stats.invalidations,
      }
    end
  else
    -- Global stats
    local total_size = 0
    for _, cache in pairs(caches) do
      total_size = total_size + vim.tbl_count(cache.entries)
    end

    return {
      caches = vim.tbl_count(caches),
      total_entries = total_size,
      hits = stats.hits,
      misses = stats.misses,
      hit_rate = stats.hits / math.max(1, stats.hits + stats.misses),
      evictions = stats.evictions,
      invalidations = stats.invalidations,
    }
  end
end

-- Reset statistics
function M.reset_stats(cache_name)
  if cache_name then
    local cache = caches[cache_name]
    if cache then
      cache.stats = {
        hits = 0,
        misses = 0,
        evictions = 0,
        invalidations = 0,
      }
    end
  else
    stats = {
      hits = 0,
      misses = 0,
      evictions = 0,
      invalidations = 0,
    }
  end
end

-- List all caches
function M.list()
  local list = {}
  for name, cache in pairs(caches) do
    table.insert(list, {
      name = name,
      size = vim.tbl_count(cache.entries),
      config = cache.config,
      stats = M.get_stats(name),
    })
  end
  return list
end

-- Persistence helpers
function M._get_cache_file(name)
  local cache_dir = vim.fn.stdpath("cache") .. "/marvim"
  vim.fn.mkdir(cache_dir, "p")
  return cache_dir .. "/" .. name .. ".cache"
end

function M._save_cache(name)
  local cache = caches[name]
  if not cache or not cache.config.persist then
    return
  end

  local file = M._get_cache_file(name)
  local data = vim.fn.json_encode(cache.entries)
  vim.fn.writefile({ data }, file)
end

function M._load_cache(name)
  local cache = caches[name]
  if not cache or not cache.config.persist then
    return
  end

  local file = M._get_cache_file(name)
  if vim.fn.filereadable(file) == 1 then
    local lines = vim.fn.readfile(file)
    if #lines > 0 then
      local ok, data = pcall(vim.fn.json_decode, lines[1])
      if ok and type(data) == "table" then
        -- Filter out expired entries
        local now = os.time()
        for key, entry in pairs(data) do
          if not entry.ttl or entry.ttl <= 0 or (now - entry.timestamp) <= entry.ttl then
            cache.entries[key] = entry
          end
        end
      end
    end
  end
end

-- Common cache presets
M.presets = {
  -- Module loading cache
  modules = {
    max_size = 50,
    ttl = 0, -- No expiration
    lru = true,
  },

  -- LSP response cache
  lsp = {
    max_size = 200,
    ttl = 60, -- 1 minute
    lru = true,
  },

  -- File system cache
  fs = {
    max_size = 100,
    ttl = 30, -- 30 seconds
    lru = true,
  },

  -- Computation results
  compute = {
    max_size = 50,
    ttl = 300, -- 5 minutes
    lru = true,
  },

  -- Session data
  session = {
    max_size = 20,
    ttl = 0, -- No expiration
    persist = true,
    lru = false,
  },
}

-- Setup common caches
function M.setup_common()
  -- Create module cache for expensive requires
  M.create("modules", M.presets.modules)

  -- Create LSP cache for server capabilities, etc.
  M.create("lsp", M.presets.lsp)

  -- Create file system cache for file checks
  M.create("fs", M.presets.fs)

  -- Create computation cache for expensive calculations
  M.create("compute", M.presets.compute)
end

-- Get statistics (alias for get_stats for consistency)
function M.stats(cache_name)
  return M.get_stats(cache_name)
end

-- Debug information
function M.debug()
  local info = {
    global_stats = M.get_stats(),
    caches = {},
  }

  for name, cache in pairs(caches) do
    info.caches[name] = {
      size = vim.tbl_count(cache.entries),
      config = cache.config,
      stats = cache.stats,
      lru_order = #cache.access_order,
    }
  end

  return info
end

-- Create user commands
function M.setup_commands()
  vim.api.nvim_create_user_command("CacheStats", function(opts)
    if opts.args ~= "" then
      local stats = M.get_stats(opts.args)
      if stats then
        print(vim.inspect(stats))
      else
        print("Cache '" .. opts.args .. "' not found")
      end
    else
      print(vim.inspect(M.get_stats()))
    end
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_keys(caches)
    end,
    desc = "Show cache statistics",
  })

  vim.api.nvim_create_user_command("CacheClear", function(opts)
    if opts.args ~= "" then
      if M.clear(opts.args) then
        vim.notify("Cache '" .. opts.args .. "' cleared", vim.log.levels.INFO)
      else
        vim.notify("Cache '" .. opts.args .. "' not found", vim.log.levels.WARN)
      end
    else
      M.clear_all()
      vim.notify("All caches cleared", vim.log.levels.INFO)
    end
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_keys(caches)
    end,
    desc = "Clear cache",
  })

  vim.api.nvim_create_user_command("CacheDebug", function()
    print(vim.inspect(M.debug()))
  end, {
    desc = "Show cache debug information",
  })
end

return M