-- MARVIM Utils
-- Common utility functions for table, string, path, and async operations

local M = {}

-- Table utilities
M.table = {}

-- Deep copy a table
function M.table.deep_copy(orig)
  local copy
  if type(orig) == "table" then
    copy = {}
    for k, v in next, orig, nil do
      copy[M.table.deep_copy(k)] = M.table.deep_copy(v)
    end
    setmetatable(copy, M.table.deep_copy(getmetatable(orig)))
  else
    copy = orig
  end
  return copy
end

-- Deep merge tables (right overwrites left)
function M.table.deep_merge(...)
  local result = {}
  for _, tbl in ipairs({ ... }) do
    if type(tbl) == "table" then
      for k, v in pairs(tbl) do
        if type(v) == "table" and type(result[k]) == "table" and not vim.islist(v) then
          result[k] = M.table.deep_merge(result[k], v)
        else
          result[k] = v
        end
      end
    end
  end
  return result
end

-- Filter table elements
function M.table.filter(tbl, fn)
  local result = {}
  for k, v in pairs(tbl) do
    if fn(v, k) then
      if type(k) == "number" then
        table.insert(result, v)
      else
        result[k] = v
      end
    end
  end
  return result
end

-- Map over table elements
function M.table.map(tbl, fn)
  local result = {}
  for k, v in pairs(tbl) do
    if type(k) == "number" then
      result[k] = fn(v, k)
    else
      result[k] = fn(v, k)
    end
  end
  return result
end

-- Reduce table to single value
function M.table.reduce(tbl, fn, initial)
  local acc = initial
  for k, v in pairs(tbl) do
    acc = fn(acc, v, k)
  end
  return acc
end

-- Check if table contains value
function M.table.contains(tbl, value)
  for _, v in pairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

-- Get table keys
function M.table.keys(tbl)
  local keys = {}
  for k in pairs(tbl) do
    table.insert(keys, k)
  end
  return keys
end

-- Get table values
function M.table.values(tbl)
  local values = {}
  for _, v in pairs(tbl) do
    table.insert(values, v)
  end
  return values
end

-- String utilities
M.string = {}

-- Trim whitespace from string
function M.string.trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Split string by delimiter
function M.string.split(str, delimiter)
  delimiter = delimiter or "%s"
  local result = {}
  for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end

-- Check if string starts with prefix
function M.string.starts_with(str, prefix)
  return str:sub(1, #prefix) == prefix
end

-- Check if string ends with suffix
function M.string.ends_with(str, suffix)
  return suffix == "" or str:sub(-#suffix) == suffix
end

-- Convert to snake_case
function M.string.to_snake_case(str)
  return str:gsub("(%u)", "_%1"):gsub("^_", ""):lower()
end

-- Convert to PascalCase
function M.string.to_pascal_case(str)
  return str:gsub("^%l", string.upper):gsub("_%l", function(s)
    return s:sub(2):upper()
  end)
end

-- Path utilities
M.path = {}

-- Join path segments
function M.path.join(...)
  local sep = package.config:sub(1, 1)
  local parts = { ... }
  return table.concat(parts, sep)
end

-- Get file extension
function M.path.extension(path)
  return path:match("^.+%.(.+)$")
end

-- Get filename without extension
function M.path.basename(path)
  return path:match("^.+/(.+)$") or path
end

-- Get directory from path
function M.path.dirname(path)
  return path:match("^(.+)/[^/]+$") or "."
end

-- Check if path exists
function M.path.exists(path)
  return vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1
end

-- Check if path is absolute
function M.path.is_absolute(path)
  return path:sub(1, 1) == "/" or path:sub(1, 1) == "~"
end

-- Expand path (resolve ~, environment variables)
function M.path.expand(path)
  return vim.fn.expand(path)
end

-- Normalize path (resolve .., ., etc.)
function M.path.normalize(path)
  return vim.fn.simplify(path)
end

-- Function utilities
M.fn = {}

-- Debounce function calls
function M.fn.debounce(fn, ms)
  local timer = nil
  return function(...)
    local args = { ... }
    if timer then
      timer:stop()
    end
    timer = vim.defer_fn(function()
      fn(unpack(args))
    end, ms)
  end
end

-- Throttle function calls
function M.fn.throttle(fn, ms)
  local last = 0
  local timer = nil
  return function(...)
    local now = vim.loop.now()
    local args = { ... }

    local function call()
      last = now
      fn(unpack(args))
    end

    if now - last >= ms then
      if timer then
        timer:stop()
        timer = nil
      end
      call()
    elseif not timer then
      timer = vim.defer_fn(call, ms - (now - last))
    end
  end
end

-- Create a function that runs once
function M.fn.once(fn)
  local called = false
  local result = nil
  return function(...)
    if not called then
      called = true
      result = fn(...)
    end
    return result
  end
end

-- Memoize function results
function M.fn.memoize(fn)
  local cache = {}
  return function(...)
    local key = vim.inspect({ ... })
    if cache[key] == nil then
      cache[key] = fn(...)
    end
    return cache[key]
  end
end

-- Async utilities
M.async = {}

-- Run function asynchronously
function M.async.run(fn, callback)
  vim.schedule(function()
    local ok, result = pcall(fn)
    if callback then
      callback(ok, result)
    end
  end)
end

-- Create a simple promise-like structure
function M.async.promise(executor)
  local pending = true
  local value = nil
  local reason = nil
  local on_resolve = {}
  local on_reject = {}

  local function resolve(val)
    if pending then
      pending = false
      value = val
      for _, fn in ipairs(on_resolve) do
        vim.schedule(function()
          fn(val)
        end)
      end
    end
  end

  local function reject(err)
    if pending then
      pending = false
      reason = err
      for _, fn in ipairs(on_reject) do
        vim.schedule(function()
          fn(err)
        end)
      end
    end
  end

  local promise = {
    then_ = function(self, on_fulfilled, on_rejected)
      if not pending then
        if value ~= nil and on_fulfilled then
          vim.schedule(function()
            on_fulfilled(value)
          end)
        elseif reason ~= nil and on_rejected then
          vim.schedule(function()
            on_rejected(reason)
          end)
        end
      else
        if on_fulfilled then
          table.insert(on_resolve, on_fulfilled)
        end
        if on_rejected then
          table.insert(on_reject, on_rejected)
        end
      end
      return self
    end,

    catch = function(self, on_rejected)
      return self:then_(nil, on_rejected)
    end,
  }

  vim.schedule(function()
    local ok, err = pcall(executor, resolve, reject)
    if not ok then
      reject(err)
    end
  end)

  return promise
end

-- Buffer utilities
M.buffer = {}

-- Check if buffer is valid
function M.buffer.is_valid(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr or 0)
end

-- Get buffer option safely
function M.buffer.get_option(bufnr, option)
  if M.buffer.is_valid(bufnr) then
    return vim.api.nvim_get_option_value(option, { buf = bufnr })
  end
  return nil
end

-- Set buffer option safely
function M.buffer.set_option(bufnr, option, value)
  if M.buffer.is_valid(bufnr) then
    vim.api.nvim_set_option_value(option, value, { buf = bufnr })
    return true
  end
  return false
end

-- Window utilities
M.window = {}

-- Check if window is valid
function M.window.is_valid(winid)
  return vim.api.nvim_win_is_valid(winid or 0)
end

-- Get current window safely
function M.window.current()
  return vim.api.nvim_get_current_win()
end

-- Focus window safely
function M.window.focus(winid)
  if M.window.is_valid(winid) then
    vim.api.nvim_set_current_win(winid)
    return true
  end
  return false
end

-- Terminal utilities
M.terminal = {}

-- Open terminal in split
function M.terminal.open(cmd, opts)
  opts = opts or {}
  local direction = opts.direction or "horizontal"
  local size = opts.size or 0.3

  if direction == "horizontal" then
    vim.cmd(string.format("split | resize %d", math.floor(vim.o.lines * size)))
  elseif direction == "vertical" then
    vim.cmd(string.format("vsplit | vertical resize %d", math.floor(vim.o.columns * size)))
  elseif direction == "float" then
    -- Create floating window
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(0, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
    })
  end

  if cmd then
    vim.cmd("terminal " .. cmd)
  else
    vim.cmd("terminal")
  end

  if opts.start_insert ~= false then
    vim.cmd("startinsert")
  end

  return vim.api.nvim_get_current_buf()
end

-- Logger utility
M.log = {}

local log_levels = {
  DEBUG = 1,
  INFO = 2,
  WARN = 3,
  ERROR = 4,
}

M.log.level = log_levels.INFO

function M.log.set_level(level)
  M.log.level = log_levels[level:upper()] or log_levels.INFO
end

local function log(level, msg, ...)
  if log_levels[level] >= M.log.level then
    local formatted = string.format(msg, ...)
    local prefix = string.format("[MARVIM][%s]", level)
    vim.notify(prefix .. " " .. formatted, vim.log.levels[level])
  end
end

function M.log.debug(msg, ...)
  log("DEBUG", msg, ...)
end

function M.log.info(msg, ...)
  log("INFO", msg, ...)
end

function M.log.warn(msg, ...)
  log("WARN", msg, ...)
end

function M.log.error(msg, ...)
  log("ERROR", msg, ...)
end

return M