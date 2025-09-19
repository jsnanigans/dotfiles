-- MARVIM Autocmd Manager
-- Centralized autocmd management with groups, deduplication, and cleanup

local M = {}

-- Store registered autocmds for management
local autocmds = {}

-- Store autocmd groups
local groups = {}

-- Default group for MARVIM autocmds
local DEFAULT_GROUP = "MarvimAutocmds"

-- Statistics for debugging
local stats = {
  created = 0,
  deleted = 0,
  groups_created = 0,
  errors = 0,
}

-- Initialize the autocmd manager
function M.setup()
  -- Create default group
  M.create_group(DEFAULT_GROUP, { clear = true })

  -- Set up cleanup on exit
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = DEFAULT_GROUP,
    callback = function()
      M.cleanup()
    end,
  })
end

-- Create or get an autocmd group
function M.create_group(name, opts)
  opts = opts or {}

  if groups[name] and not opts.clear then
    return groups[name]
  end

  local group = vim.api.nvim_create_augroup(name, {
    clear = opts.clear ~= false,
  })

  groups[name] = group
  stats.groups_created = stats.groups_created + 1

  return group
end

-- Delete an autocmd group
function M.delete_group(name)
  if groups[name] then
    pcall(vim.api.nvim_del_augroup_by_id, groups[name])
    groups[name] = nil

    -- Remove all autocmds associated with this group
    for id, autocmd in pairs(autocmds) do
      if autocmd.group == name then
        autocmds[id] = nil
      end
    end
  end
end

-- Create an autocmd with enhanced features
function M.create(event, opts)
  opts = opts or {}

  -- Validate required fields
  if not event then
    error("Event is required for autocmd")
  end

  if not opts.callback and not opts.command then
    error("Either callback or command is required for autocmd")
  end

  -- Set default group if not specified
  local group_name = opts.group or DEFAULT_GROUP
  local group = groups[group_name]

  if not group then
    group = M.create_group(group_name)
  end

  -- Build autocmd options
  local autocmd_opts = {
    group = group,
    pattern = opts.pattern or "*",
    callback = opts.callback,
    command = opts.command,
    once = opts.once or false,
    nested = opts.nested or false,
    desc = opts.desc or string.format("Autocmd for %s", event),
  }

  -- Handle buffer-local autocmds
  if opts.buffer ~= nil then
    autocmd_opts.buffer = opts.buffer
    autocmd_opts.pattern = nil
  end

  -- Wrap callback with error handling
  if autocmd_opts.callback then
    local original_callback = autocmd_opts.callback
    autocmd_opts.callback = function(args)
      local ok, err = pcall(original_callback, args)
      if not ok then
        stats.errors = stats.errors + 1
        vim.notify(
          string.format("Autocmd error in %s: %s", event, err),
          vim.log.levels.ERROR
        )
      end
    end
  end

  -- Create the autocmd
  local id = vim.api.nvim_create_autocmd(event, autocmd_opts)

  -- Store for management
  autocmds[id] = {
    id = id,
    event = event,
    group = group_name,
    pattern = opts.pattern,
    buffer = opts.buffer,
    desc = autocmd_opts.desc,
    created_at = os.time(),
  }

  stats.created = stats.created + 1

  return id
end

-- Delete an autocmd by ID
function M.delete(id)
  if autocmds[id] then
    pcall(vim.api.nvim_del_autocmd, id)
    autocmds[id] = nil
    stats.deleted = stats.deleted + 1
    return true
  end
  return false
end

-- Create multiple autocmds at once
function M.bulk_create(definitions)
  local created_ids = {}

  for _, def in ipairs(definitions) do
    local event = def[1] or def.event
    local opts = def[2] or def

    local ok, id = pcall(M.create, event, opts)
    if ok then
      table.insert(created_ids, id)
    else
      vim.notify(
        string.format("Failed to create autocmd for %s: %s", event, id),
        vim.log.levels.WARN
      )
    end
  end

  return created_ids
end

-- Common autocmd patterns
M.patterns = {}

-- Create autocmd for specific filetypes
function M.patterns.filetype(filetypes, opts)
  if type(filetypes) == "string" then
    filetypes = { filetypes }
  end

  return M.create("FileType", vim.tbl_extend("force", opts, {
    pattern = filetypes,
  }))
end

-- Create autocmd for buffer events
function M.patterns.buffer(event, bufnr, opts)
  return M.create(event, vim.tbl_extend("force", opts, {
    buffer = bufnr or 0,
  }))
end

-- Create autocmd that runs once
function M.patterns.once(event, opts)
  return M.create(event, vim.tbl_extend("force", opts, {
    once = true,
  }))
end

-- Create autocmd with debouncing
function M.patterns.debounced(event, ms, opts)
  local timer = nil
  local callback = opts.callback

  opts.callback = function(args)
    if timer then
      vim.fn.timer_stop(timer)
    end
    timer = vim.fn.timer_start(ms, function()
      callback(args)
    end)
  end

  return M.create(event, opts)
end

-- Create autocmd with throttling
function M.patterns.throttled(event, ms, opts)
  local last = 0
  local callback = opts.callback

  opts.callback = function(args)
    local now = vim.loop.now()
    if now - last >= ms then
      last = now
      callback(args)
    end
  end

  return M.create(event, opts)
end

-- LSP-specific autocmds
function M.on_lsp_attach(callback, opts)
  opts = opts or {}

  return M.create("LspAttach", {
    group = opts.group or "MarvimLsp",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local bufnr = args.buf

      if client then
        callback(client, bufnr)
      end
    end,
    desc = opts.desc or "LSP attach handler",
  })
end

-- User event helpers
function M.on_user(pattern, callback, opts)
  opts = opts or {}

  return M.create("User", vim.tbl_extend("force", opts, {
    pattern = pattern,
    callback = callback,
  }))
end

-- Emit a User event
function M.emit_user(pattern, data)
  vim.api.nvim_exec_autocmds("User", {
    pattern = pattern,
    data = data,
  })
end

-- Find autocmds by criteria
function M.find(criteria)
  local results = {}

  for id, autocmd in pairs(autocmds) do
    local match = true

    if criteria.event and autocmd.event ~= criteria.event then
      match = false
    end

    if criteria.group and autocmd.group ~= criteria.group then
      match = false
    end

    if criteria.pattern and autocmd.pattern ~= criteria.pattern then
      match = false
    end

    if criteria.buffer and autocmd.buffer ~= criteria.buffer then
      match = false
    end

    if match then
      table.insert(results, autocmd)
    end
  end

  return results
end

-- Clear all autocmds in a group
function M.clear_group(name)
  local group = groups[name]
  if group then
    vim.api.nvim_clear_autocmds({ group = group })

    -- Remove from tracking
    for id, autocmd in pairs(autocmds) do
      if autocmd.group == name then
        autocmds[id] = nil
        stats.deleted = stats.deleted + 1
      end
    end
  end
end

-- Clear all buffer-local autocmds
function M.clear_buffer(bufnr)
  bufnr = bufnr or 0

  vim.api.nvim_clear_autocmds({ buffer = bufnr })

  -- Remove from tracking
  for id, autocmd in pairs(autocmds) do
    if autocmd.buffer == bufnr then
      autocmds[id] = nil
      stats.deleted = stats.deleted + 1
    end
  end
end

-- Cleanup all managed autocmds
function M.cleanup()
  -- Clear all groups except Neovim defaults
  for name, group in pairs(groups) do
    if name ~= DEFAULT_GROUP then
      pcall(vim.api.nvim_del_augroup_by_id, group)
    end
  end

  -- Clear tracking
  autocmds = {}
  groups = { [DEFAULT_GROUP] = groups[DEFAULT_GROUP] }
end

-- Get statistics
function M.stats()
  return vim.deepcopy(stats)
end

-- Debug information
function M.debug()
  local info = {
    stats = M.stats(),
    groups = vim.tbl_keys(groups),
    autocmds_count = vim.tbl_count(autocmds),
    recent_errors = stats.errors,
  }

  -- Group autocmds by event
  info.by_event = {}
  for _, autocmd in pairs(autocmds) do
    info.by_event[autocmd.event] = (info.by_event[autocmd.event] or 0) + 1
  end

  -- Group autocmds by group
  info.by_group = {}
  for _, autocmd in pairs(autocmds) do
    info.by_group[autocmd.group] = (info.by_group[autocmd.group] or 0) + 1
  end

  return info
end

-- List all managed autocmds
function M.list()
  local list = {}
  for _, autocmd in pairs(autocmds) do
    table.insert(list, autocmd)
  end
  table.sort(list, function(a, b)
    return a.created_at < b.created_at
  end)
  return list
end

return M