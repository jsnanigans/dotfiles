---@class Marvim.Migrate
---@field deprecated table<string, boolean> Track deprecated warnings shown
---@field shims table<string, function> Backward compatibility shims
---@field replacements table<string, string> Pattern replacements for migration
local M = {}

-- Track which deprecation warnings have been shown
M.deprecated = {}

-- Track active shims
M.shims = {}

-- Pattern replacements for common migrations
M.replacements = {
  ["pcall%(require,"] = "marvim.module.safe_require(",
  ["pcall%(require%("] = "marvim.module.safe_require(",
  ["vim%.api%.nvim_create_autocmd"] = "marvim.autocmd.create",
  ["vim%.api%.nvim_create_augroup"] = "marvim.autocmd.group",
  ["vim%.keymap%.set"] = "marvim.utils.keymap",
}

---Show deprecation warning once per pattern
---@param old_pattern string The deprecated pattern
---@param new_pattern string The recommended replacement
---@param context? string Additional context about the deprecation
function M.deprecate(old_pattern, new_pattern, context)
  local key = old_pattern .. "->" .. new_pattern
  if M.deprecated[key] then
    return
  end

  M.deprecated[key] = true

  local msg = string.format(
    "[MARVIM] Deprecated: '%s' -> use '%s' instead",
    old_pattern,
    new_pattern
  )

  if context then
    msg = msg .. " (" .. context .. ")"
  end

  vim.schedule(function()
    vim.notify(msg, vim.log.levels.WARN, { title = "MARVIM Migration" })
  end)
end

---Create a shim function that wraps old API with new implementation
---@param name string The name of the shim
---@param old_fn function The old function to wrap
---@param new_fn function The new function to call
---@param deprecation_msg? string Custom deprecation message
---@return function
function M.shim(name, old_fn, new_fn, deprecation_msg)
  M.shims[name] = function(...)
    if deprecation_msg then
      M.deprecate(name, deprecation_msg, "shim")
    end
    -- Try new function first, fall back to old if it fails
    local ok, result = pcall(new_fn, ...)
    if ok then
      return result
    else
      return old_fn(...)
    end
  end
  return M.shims[name]
end

---Install backward compatibility shims for common patterns
function M.install_shims()
  local marvim = require("marvim")

  -- Shim for old pcall(require) pattern
  local old_require = require
  _G.require = function(modname)
    -- Detect pcall(require) pattern
    local info = debug.getinfo(2, "n")
    if info and info.name == "pcall" then
      M.deprecate(
        "pcall(require, '" .. modname .. "')",
        "marvim.module.safe_require('" .. modname .. "')",
        "use framework's safe loading"
      )
    end
    return old_require(modname)
  end

  -- Shim for direct autocmd creation
  local old_create_autocmd = vim.api.nvim_create_autocmd
  vim.api.nvim_create_autocmd = function(event, opts)
    -- Only warn for user code, not plugin code
    local source = debug.getinfo(2, "S").source
    if source:match("config/") or source:match("lua/config/") then
      M.deprecate(
        "vim.api.nvim_create_autocmd",
        "marvim.autocmd.create",
        "use centralized autocmd manager"
      )
    end
    return old_create_autocmd(event, opts)
  end

  -- Shim for direct keymap setting
  local old_keymap_set = vim.keymap.set
  vim.keymap.set = function(mode, lhs, rhs, opts)
    -- Only warn for user config code
    local source = debug.getinfo(2, "S").source
    if source:match("config/") and not source:match("marvim/") then
      M.deprecate(
        "vim.keymap.set",
        "marvim.utils.keymap",
        "use framework keymap utilities"
      )
    end
    return old_keymap_set(mode, lhs, rhs, opts)
  end
end

---Helper to migrate a Lua file to new patterns
---@param filepath string Path to the file to migrate
---@param dry_run? boolean If true, only show what would change
---@return table|nil migrations List of migrations that would be applied
function M.migrate_file(filepath, dry_run)
  local content = vim.fn.readfile(filepath)
  if not content or #content == 0 then
    return nil
  end

  local migrations = {}
  local changed = false

  for i, line in ipairs(content) do
    local original = line

    -- Apply pattern replacements
    for old_pattern, new_pattern in pairs(M.replacements) do
      if line:match(old_pattern) then
        line = line:gsub(old_pattern, new_pattern)
        table.insert(migrations, {
          line = i,
          old = original,
          new = line,
          pattern = old_pattern,
        })
        changed = true
      end
    end

    if not dry_run and line ~= original then
      content[i] = line
    end
  end

  if not dry_run and changed then
    vim.fn.writefile(content, filepath)
  end

  return migrations
end

---Migrate old module pattern to new framework
---@param old_module table The old module table
---@param module_name string The name of the module
---@return table migrated The migrated module
function M.migrate_module(old_module, module_name)
  local marvim = require("marvim")

  -- Create new module using framework
  local new_module = marvim.module.create(module_name)

  -- Copy over functionality
  for key, value in pairs(old_module) do
    if key ~= "setup" and key ~= "init" then
      new_module[key] = value
    end
  end

  -- Wrap setup function if it exists
  if old_module.setup then
    new_module:setup(function(opts)
      -- Show migration notice
      M.deprecate(
        module_name .. ".setup()",
        "marvim.module('" .. module_name .. "'):setup()",
        "module migrated to framework"
      )

      -- Call original setup
      return old_module.setup(opts)
    end)
  end

  return new_module
end

---Convert old keymap definition to new format
---@param old_keymap table Old keymap definition
---@return table new_keymap Converted keymap
function M.migrate_keymap(old_keymap)
  local marvim = require("marvim")

  -- Handle different keymap formats
  if type(old_keymap) == "table" then
    if old_keymap[1] and old_keymap[2] then
      -- Array format: { "lhs", "rhs", opts }
      return marvim.utils.keymap(
        old_keymap.mode or "n",
        old_keymap[1],
        old_keymap[2],
        old_keymap[3] or old_keymap
      )
    elseif old_keymap.lhs and old_keymap.rhs then
      -- Table format with lhs/rhs
      return marvim.utils.keymap(
        old_keymap.mode or "n",
        old_keymap.lhs,
        old_keymap.rhs,
        old_keymap
      )
    end
  end

  return old_keymap
end

---Convert old autocmd to new framework format
---@param event string|string[] Event name(s)
---@param opts table Autocmd options
---@return number autocmd_id The new autocmd ID
function M.migrate_autocmd(event, opts)
  local marvim = require("marvim")

  M.deprecate(
    "direct autocmd creation",
    "marvim.autocmd.create",
    "using framework autocmd manager"
  )

  -- Convert to new format
  return marvim.autocmd.create(event, {
    pattern = opts.pattern,
    callback = opts.callback or opts.command and function()
      vim.cmd(opts.command)
    end,
    group = opts.group,
    desc = opts.desc or opts.description,
    once = opts.once,
    nested = opts.nested,
    buffer = opts.buffer,
  })
end

---Check a module for migration opportunities
---@param module_name string The module to check
---@return table report Migration report
function M.check_module(module_name)
  local report = {
    module = module_name,
    issues = {},
    suggestions = {},
  }

  -- Try to load module source
  local path = vim.fn.stdpath("config") .. "/lua/" .. module_name:gsub("%.", "/") .. ".lua"
  local content = vim.fn.readfile(path)

  if content then
    for i, line in ipairs(content) do
      -- Check for old patterns
      if line:match("pcall%(require") then
        table.insert(report.issues, {
          line = i,
          pattern = "pcall(require)",
          suggestion = "Use marvim.module.safe_require()",
        })
      end

      if line:match("vim%.api%.nvim_create_autocmd") then
        table.insert(report.issues, {
          line = i,
          pattern = "vim.api.nvim_create_autocmd",
          suggestion = "Use marvim.autocmd.create()",
        })
      end

      if line:match("vim%.keymap%.set") then
        table.insert(report.issues, {
          line = i,
          pattern = "vim.keymap.set",
          suggestion = "Use marvim.utils.keymap()",
        })
      end
    end
  end

  return report
end

---Generate migration report for entire config
---@return table report Full migration report
function M.generate_report()
  local report = {
    timestamp = os.date("%Y-%m-%d %H:%M:%S"),
    modules = {},
    summary = {
      total_issues = 0,
      by_pattern = {},
    },
  }

  -- Scan all config modules
  local config_path = vim.fn.stdpath("config") .. "/lua/config"
  local files = vim.fn.globpath(config_path, "**/*.lua", false, true)

  for _, file in ipairs(files) do
    local module_name = file:match("lua/(.+)%.lua$"):gsub("/", ".")
    local module_report = M.check_module(module_name)

    if #module_report.issues > 0 then
      table.insert(report.modules, module_report)
      report.summary.total_issues = report.summary.total_issues + #module_report.issues

      for _, issue in ipairs(module_report.issues) do
        report.summary.by_pattern[issue.pattern] =
          (report.summary.by_pattern[issue.pattern] or 0) + 1
      end
    end
  end

  return report
end

---Interactive migration wizard
function M.wizard()
  local marvim = require("marvim")

  vim.ui.select(
    { "Check Status", "Install Shims", "Migrate File", "Generate Report", "Cancel" },
    { prompt = "MARVIM Migration Wizard" },
    function(choice)
      if choice == "Check Status" then
        local report = M.generate_report()
        vim.notify(
          string.format(
            "Migration Status:\n" ..
            "Total Issues: %d\n" ..
            "Modules Affected: %d\n" ..
            "Run ':MarvimMigrate report' for details",
            report.summary.total_issues,
            #report.modules
          ),
          vim.log.levels.INFO,
          { title = "MARVIM Migration" }
        )

      elseif choice == "Install Shims" then
        M.install_shims()
        vim.notify(
          "Backward compatibility shims installed.\n" ..
          "Old patterns will show deprecation warnings.",
          vim.log.levels.INFO,
          { title = "MARVIM Migration" }
        )

      elseif choice == "Migrate File" then
        vim.ui.input(
          { prompt = "File to migrate (relative to config): " },
          function(input)
            if input then
              local path = vim.fn.stdpath("config") .. "/lua/" .. input
              local migrations = M.migrate_file(path, true)
              if migrations and #migrations > 0 then
                vim.notify(
                  string.format("Found %d patterns to migrate", #migrations),
                  vim.log.levels.INFO,
                  { title = "MARVIM Migration" }
                )

                vim.ui.select(
                  { "Apply Migrations", "Cancel" },
                  { prompt = "Apply migrations?" },
                  function(apply)
                    if apply == "Apply Migrations" then
                      M.migrate_file(path, false)
                      vim.notify("File migrated successfully", vim.log.levels.INFO)
                    end
                  end
                )
              else
                vim.notify("No migrations needed", vim.log.levels.INFO)
              end
            end
          end
        )

      elseif choice == "Generate Report" then
        local report = M.generate_report()
        local report_path = vim.fn.stdpath("config") .. "/migration-report.md"

        local lines = {
          "# MARVIM Migration Report",
          "",
          "Generated: " .. report.timestamp,
          "",
          "## Summary",
          "",
          "- Total Issues: " .. report.summary.total_issues,
          "- Modules Affected: " .. #report.modules,
          "",
          "## Issues by Pattern",
          "",
        }

        for pattern, count in pairs(report.summary.by_pattern) do
          table.insert(lines, string.format("- `%s`: %d occurrences", pattern, count))
        end

        table.insert(lines, "")
        table.insert(lines, "## Module Details")
        table.insert(lines, "")

        for _, module in ipairs(report.modules) do
          table.insert(lines, "### " .. module.module)
          table.insert(lines, "")
          for _, issue in ipairs(module.issues) do
            table.insert(lines, string.format(
              "- Line %d: `%s` -> %s",
              issue.line,
              issue.pattern,
              issue.suggestion
            ))
          end
          table.insert(lines, "")
        end

        vim.fn.writefile(lines, report_path)
        vim.notify("Report saved to: " .. report_path, vim.log.levels.INFO)
      end
    end
  )
end

-- Setup commands
function M.setup()
  vim.api.nvim_create_user_command("MarvimMigrate", function(opts)
    local subcmd = opts.args

    if subcmd == "wizard" then
      M.wizard()
    elseif subcmd == "shims" then
      M.install_shims()
      print("Migration shims installed")
    elseif subcmd == "report" then
      local report = M.generate_report()
      print(vim.inspect(report))
    elseif subcmd == "check" then
      local module = vim.fn.input("Module to check: ")
      if module ~= "" then
        local report = M.check_module(module)
        print(vim.inspect(report))
      end
    else
      print("Usage: :MarvimMigrate [wizard|shims|report|check]")
    end
  end, {
    nargs = "?",
    complete = function()
      return { "wizard", "shims", "report", "check" }
    end,
    desc = "MARVIM migration utilities",
  })
end

return M