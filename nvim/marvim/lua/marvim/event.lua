-- MARVIM Event System
-- Provides event emitter pattern for decoupled module communication

local M = {}

-- Store event listeners
local listeners = {}

-- Store event history for debugging
local event_history = {}
local max_history_size = 100

-- Store one-time listeners
local once_listeners = {}

-- Event namespacing support
local namespaces = {}

-- Register an event listener
-- @param event string: Event name (can be namespaced like "lsp:attach")
-- @param handler function: Callback function
-- @param opts table: Optional settings {namespace, priority, once}
function M.on(event, handler, opts)
  opts = opts or {}

  if type(event) ~= "string" or event == "" then
    error("Event name must be a non-empty string")
  end

  if type(handler) ~= "function" then
    error("Event handler must be a function")
  end

  -- Handle namespaced events
  local namespace = opts.namespace
  if namespace then
    event = namespace .. ":" .. event
  end

  -- Initialize listener list for this event
  if not listeners[event] then
    listeners[event] = {}
  end

  -- Create listener entry
  local listener = {
    handler = handler,
    priority = opts.priority or 50,
    namespace = namespace,
    id = vim.fn.id(handler),
  }

  -- Add to appropriate list
  if opts.once then
    if not once_listeners[event] then
      once_listeners[event] = {}
    end
    table.insert(once_listeners[event], listener)
  else
    table.insert(listeners[event], listener)
  end

  -- Sort by priority (higher priority runs first)
  table.sort(listeners[event], function(a, b)
    return a.priority > b.priority
  end)

  -- Track namespace
  if namespace then
    if not namespaces[namespace] then
      namespaces[namespace] = {}
    end
    table.insert(namespaces[namespace], event)
  end

  -- Return a function to remove this listener
  return function()
    M.off(event, handler)
  end
end

-- Register a one-time event listener
function M.once(event, handler, opts)
  opts = opts or {}
  opts.once = true
  return M.on(event, handler, opts)
end

-- Remove an event listener
function M.off(event, handler)
  if not event then
    -- Clear all listeners
    listeners = {}
    once_listeners = {}
    return
  end

  if not handler then
    -- Clear all listeners for this event
    listeners[event] = nil
    once_listeners[event] = nil
    return
  end

  -- Remove specific handler
  local handler_id = vim.fn.id(handler)

  if listeners[event] then
    for i = #listeners[event], 1, -1 do
      if listeners[event][i].id == handler_id then
        table.remove(listeners[event], i)
      end
    end
  end

  if once_listeners[event] then
    for i = #once_listeners[event], 1, -1 do
      if once_listeners[event][i].id == handler_id then
        table.remove(once_listeners[event], i)
      end
    end
  end
end

-- Emit an event
-- @param event string: Event name
-- @param ... any: Arguments to pass to handlers
function M.emit(event, ...)
  -- Record in history for debugging
  table.insert(event_history, {
    event = event,
    timestamp = vim.fn.reltime(),
    args = { ... },
  })

  -- Trim history if too large
  if #event_history > max_history_size then
    table.remove(event_history, 1)
  end

  local handlers_called = 0
  local errors = {}

  -- Call regular listeners
  if listeners[event] then
    for _, listener in ipairs(listeners[event]) do
      local ok, err = pcall(listener.handler, ...)
      if not ok then
        table.insert(errors, {
          event = event,
          handler = listener.id,
          error = err,
        })
      else
        handlers_called = handlers_called + 1
      end
    end
  end

  -- Call one-time listeners and remove them
  if once_listeners[event] then
    local once_list = once_listeners[event]
    once_listeners[event] = nil -- Clear before calling to prevent recursion

    for _, listener in ipairs(once_list) do
      local ok, err = pcall(listener.handler, ...)
      if not ok then
        table.insert(errors, {
          event = event,
          handler = listener.id,
          error = err,
        })
      else
        handlers_called = handlers_called + 1
      end
    end
  end

  -- Report errors if any
  if #errors > 0 then
    for _, error_info in ipairs(errors) do
      vim.notify(
        string.format("Event handler error for '%s': %s", error_info.event, error_info.error),
        vim.log.levels.ERROR
      )
    end
  end

  return handlers_called, errors
end

-- Emit an event asynchronously
function M.emit_async(event, ...)
  local args = { ... }
  vim.schedule(function()
    M.emit(event, unpack(args))
  end)
end

-- Wait for an event (returns a promise-like function)
function M.wait_for(event, timeout_ms)
  timeout_ms = timeout_ms or 5000

  local co = coroutine.running()
  if not co then
    error("wait_for must be called from a coroutine")
  end

  local result = nil
  local timer = nil

  -- Set up one-time listener
  local unsubscribe = M.once(event, function(...)
    result = { ... }
    if timer then
      timer:stop()
    end
    coroutine.resume(co)
  end)

  -- Set up timeout
  timer = vim.loop.new_timer()
  timer:start(timeout_ms, 0, function()
    unsubscribe()
    coroutine.resume(co, nil, "timeout")
  end)

  -- Yield and wait for event or timeout
  local _, err = coroutine.yield()

  if err == "timeout" then
    return nil, "timeout"
  end

  return result
end

-- Get all listeners for an event
function M.get_listeners(event)
  local all = {}

  if listeners[event] then
    for _, l in ipairs(listeners[event]) do
      table.insert(all, {
        type = "regular",
        priority = l.priority,
        namespace = l.namespace,
      })
    end
  end

  if once_listeners[event] then
    for _, l in ipairs(once_listeners[event]) do
      table.insert(all, {
        type = "once",
        priority = l.priority,
        namespace = l.namespace,
      })
    end
  end

  return all
end

-- List all registered events
function M.list_events()
  local events = {}

  for event in pairs(listeners) do
    events[event] = true
  end

  for event in pairs(once_listeners) do
    events[event] = true
  end

  return vim.tbl_keys(events)
end

-- Clear events for a namespace
function M.clear_namespace(namespace)
  if not namespaces[namespace] then
    return
  end

  for _, event in ipairs(namespaces[namespace]) do
    listeners[event] = nil
    once_listeners[event] = nil
  end

  namespaces[namespace] = nil
end

-- Get event history
function M.get_history(limit)
  limit = limit or 20
  local start = math.max(1, #event_history - limit + 1)
  local history = {}

  for i = start, #event_history do
    table.insert(history, event_history[i])
  end

  return history
end

-- Clear event history
function M.clear_history()
  event_history = {}
end

-- Setup common framework events
function M.setup_common()
  -- Create namespaced events for common patterns

  -- LSP events
  M.on("LspAttach", function(client, buffer)
    -- This is a framework-level handler that other modules can hook into
    M.emit("lsp:capabilities_ready", client.server_capabilities, buffer)
  end, { priority = 100 })

  -- Buffer events
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
      M.emit("buffer:enter", args.buf, args.file)
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(args)
      M.emit("buffer:before_save", args.buf, args.file)
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function(args)
      M.emit("buffer:after_save", args.buf, args.file)
    end,
  })

  -- Window events
  vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
      M.emit("window:enter", vim.api.nvim_get_current_win())
    end,
  })
end

-- Debug info
function M.debug()
  return {
    events = M.list_events(),
    listeners_count = vim.tbl_count(listeners),
    once_listeners_count = vim.tbl_count(once_listeners),
    namespaces = vim.tbl_keys(namespaces),
    recent_history = M.get_history(10),
  }
end

-- Create user commands
function M.setup_commands()
  vim.api.nvim_create_user_command("EventDebug", function()
    local info = M.debug()
    print("MARVIM Event System Debug:")
    print("  Events: " .. vim.inspect(info.events))
    print("  Namespaces: " .. vim.inspect(info.namespaces))
    print("  Recent History:")
    for _, entry in ipairs(info.recent_history) do
      print("    " .. entry.event)
    end
  end, { desc = "Show event system debug info" })

  vim.api.nvim_create_user_command("EventHistory", function(opts)
    local limit = tonumber(opts.args) or 20
    local history = M.get_history(limit)
    print("Recent Event History:")
    for i, entry in ipairs(history) do
      print(string.format("%d. %s", i, entry.event))
    end
  end, {
    nargs = "?",
    desc = "Show recent event history",
  })
end

return M