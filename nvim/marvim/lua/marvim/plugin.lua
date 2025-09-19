-- MARVIM Plugin API
-- Wrapper around lazy.nvim with consistent error handling and configuration patterns

local M = {}

-- Store plugin specifications
local specs = {}

-- Store plugin load status
local load_status = {}

-- Plugin configuration defaults
local defaults = {
  error_handler = function(plugin_name, err)
    vim.notify(
      string.format("Plugin '%s' error: %s", plugin_name, err),
      vim.log.levels.ERROR
    )
  end,
  auto_pcall = true,
  notify_on_error = true,
}

-- Safely require a module with error handling
function M.safe_require(module_name, opts)
  opts = opts or {}

  local ok, result = pcall(require, module_name)

  if not ok then
    if opts.silent ~= true and defaults.notify_on_error then
      defaults.error_handler(module_name, result)
    end

    if opts.default ~= nil then
      return opts.default
    end

    return nil
  end

  return result
end

-- Wrap a function with pcall and error handling
function M.wrap(fn, plugin_name)
  return function(...)
    local ok, result = pcall(fn, ...)
    if not ok then
      if defaults.notify_on_error then
        defaults.error_handler(plugin_name or "unknown", result)
      end
      return nil
    end
    return result
  end
end

-- Create a plugin specification with consistent patterns
-- @param spec table: Plugin specification
-- @return table: Enhanced specification
function M.create(spec)
  if type(spec) ~= "table" then
    error("Plugin spec must be a table")
  end

  -- Extract plugin name
  local name = spec[1] or spec.name
  if not name then
    error("Plugin must have a name")
  end

  -- Store original spec
  specs[name] = vim.deepcopy(spec)

  -- Enhance configuration function
  if spec.config then
    local original_config = spec.config
    spec.config = function(plugin, opts)
      -- Mark as loading
      load_status[name] = "loading"

      -- Emit loading event
      local events = M.safe_require("marvim.event", { silent = true })
      if events then
        events.emit("plugin:before_config", name, opts)
      end

      -- Run config with error handling
      local ok, err = pcall(original_config, plugin, opts)

      if ok then
        load_status[name] = "loaded"
        if events then
          events.emit("plugin:after_config", name, opts)
        end
      else
        load_status[name] = "error"
        if defaults.notify_on_error then
          defaults.error_handler(name, err)
        end
        if events then
          events.emit("plugin:config_error", name, err)
        end
      end
    end
  end

  -- Enhance init function
  if spec.init then
    local original_init = spec.init
    spec.init = function(plugin)
      local ok, err = pcall(original_init, plugin)
      if not ok and defaults.notify_on_error then
        defaults.error_handler(name, "init error: " .. err)
      end
    end
  end

  -- Handle dependencies with safe loading
  if spec.dependencies then
    for i, dep in ipairs(spec.dependencies) do
      if type(dep) == "table" and dep.config then
        local dep_name = dep[1] or dep.name
        local original_dep_config = dep.config
        dep.config = M.wrap(original_dep_config, dep_name)
        spec.dependencies[i] = dep
      end
    end
  end

  -- Add common keys management
  if spec.keys then
    -- Wrap key handlers in pcall
    local process_keys = function(keys)
      if type(keys) == "function" then
        return M.wrap(keys, name)
      elseif type(keys) == "table" then
        for i, key in ipairs(keys) do
          if type(key) == "table" and type(key[2]) == "function" then
            key[2] = M.wrap(key[2], name)
            keys[i] = key
          end
        end
        return keys
      end
      return keys
    end

    spec.keys = process_keys(spec.keys)
  end

  -- Add module field for lazy loading pattern
  if spec.module then
    spec.lazy = true
    spec.config = function()
      return M.safe_require(spec.module)
    end
  end

  return spec
end

-- Batch create multiple plugins
function M.create_batch(specs_list)
  local enhanced = {}
  for _, spec in ipairs(specs_list) do
    table.insert(enhanced, M.create(spec))
  end
  return enhanced
end

-- Merge plugin options with defaults
function M.merge_opts(plugin_opts, user_opts, defaults)
  defaults = defaults or {}
  plugin_opts = plugin_opts or {}
  user_opts = user_opts or {}

  -- Deep merge with precedence: user > plugin > defaults
  return vim.tbl_deep_extend("force", defaults, plugin_opts, user_opts)
end

-- Setup a plugin with lazy loading support
function M.setup(name, opts)
  opts = opts or {}

  -- Check if already loaded
  if load_status[name] == "loaded" then
    return M.safe_require(name)
  end

  -- Try to load the plugin
  local plugin = M.safe_require(name, { silent = opts.optional })

  if plugin then
    load_status[name] = "loaded"

    -- Call setup if available
    if plugin.setup and type(plugin.setup) == "function" then
      local ok, err = pcall(plugin.setup, opts)
      if not ok then
        load_status[name] = "error"
        if defaults.notify_on_error then
          defaults.error_handler(name, "setup error: " .. err)
        end
        return nil
      end
    end
  else
    load_status[name] = "not_found"
  end

  return plugin
end

-- Check if a plugin is loaded
function M.is_loaded(name)
  return load_status[name] == "loaded"
end

-- Get plugin load status
function M.get_status(name)
  return load_status[name] or "unknown"
end

-- List all plugin statuses
function M.list()
  local list = {}
  for name, status in pairs(load_status) do
    table.insert(list, { name = name, status = status })
  end
  table.sort(list, function(a, b) return a.name < b.name end)
  return list
end

-- Helper for creating lazy-loaded command plugins
function M.command(cmd, module, opts)
  opts = opts or {}
  return {
    module,
    cmd = cmd,
    config = function()
      local plugin = M.safe_require(module)
      if plugin and plugin.setup then
        plugin.setup(opts)
      end
    end,
  }
end

-- Helper for creating filetype-specific plugins
function M.filetype(ft, module, opts)
  opts = opts or {}
  return {
    module,
    ft = ft,
    config = function()
      local plugin = M.safe_require(module)
      if plugin and plugin.setup then
        plugin.setup(opts)
      end
    end,
  }
end

-- Helper for creating event-triggered plugins
function M.event(event, module, opts)
  opts = opts or {}
  return {
    module,
    event = event,
    config = function()
      local plugin = M.safe_require(module)
      if plugin and plugin.setup then
        plugin.setup(opts)
      end
    end,
  }
end

-- Common plugin patterns
M.patterns = {
  -- LSP server setup pattern
  lsp_server = function(server_name, opts)
    return function()
      local lspconfig = M.safe_require("lspconfig")
      if lspconfig and lspconfig[server_name] then
        lspconfig[server_name].setup(opts or {})
      end
    end
  end,

  -- Treesitter parser setup pattern
  treesitter_parser = function(languages)
    return function()
      local configs = M.safe_require("nvim-treesitter.configs")
      if configs then
        configs.setup({
          ensure_installed = languages,
          highlight = { enable = true },
        })
      end
    end
  end,

  -- Telescope extension pattern
  telescope_extension = function(ext_name)
    return function()
      local telescope = M.safe_require("telescope")
      if telescope then
        local ok = pcall(telescope.load_extension, ext_name)
        if not ok and defaults.notify_on_error then
          vim.notify("Failed to load telescope extension: " .. ext_name, vim.log.levels.WARN)
        end
      end
    end
  end,
}

-- Configure default settings
function M.configure(opts)
  defaults = vim.tbl_deep_extend("force", defaults, opts or {})
end

-- Get plugin specification
function M.get_spec(name)
  return specs[name]
end

-- Debug information
function M.debug()
  return {
    loaded_count = vim.tbl_count(vim.tbl_filter(function(s) return s == "loaded" end, load_status)),
    error_count = vim.tbl_count(vim.tbl_filter(function(s) return s == "error" end, load_status)),
    status_list = M.list(),
    defaults = defaults,
  }
end

-- Create user commands
function M.setup_commands()
  vim.api.nvim_create_user_command("PluginStatus", function(opts)
    if opts.args ~= "" then
      -- Show specific plugin status
      local status = M.get_status(opts.args)
      print(string.format("Plugin '%s': %s", opts.args, status))
    else
      -- Show all plugin statuses
      local list = M.list()
      print("Plugin Status:")
      for _, item in ipairs(list) do
        print(string.format("  %s: %s", item.name, item.status))
      end
    end
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_keys(load_status)
    end,
    desc = "Show plugin load status",
  })

  vim.api.nvim_create_user_command("PluginReload", function(opts)
    local name = opts.args
    if name == "" then
      vim.notify("Please specify a plugin name", vim.log.levels.WARN)
      return
    end

    -- Clear from package.loaded
    package.loaded[name] = nil
    load_status[name] = nil

    -- Try to reload
    local plugin = M.setup(name)
    if plugin then
      vim.notify("Plugin '" .. name .. "' reloaded", vim.log.levels.INFO)
    end
  end, {
    nargs = 1,
    complete = function()
      return vim.tbl_keys(load_status)
    end,
    desc = "Reload a plugin",
  })
end

return M