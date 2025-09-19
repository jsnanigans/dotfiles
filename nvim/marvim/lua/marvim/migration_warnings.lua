-- MARVIM Migration Warnings
-- Provides deprecation warnings and migration guidance for old patterns

local M = {}

-- Track warnings that have already been shown
local shown_warnings = {}

-- Common patterns to detect and warn about
local patterns_to_detect = {
  {
    pattern = "pcall%(require",
    message = "Use marvim.module.safe_require() instead of pcall(require)",
    docs = "See :h marvim.module for safer module loading",
  },
  {
    pattern = "vim%.api%.nvim_create_autocmd",
    message = "Use marvim.autocmd.create() for centralized autocmd management",
    docs = "See :h marvim.autocmd for autocmd management",
  },
  {
    pattern = "vim%.api%.nvim_create_augroup",
    message = "Use marvim.autocmd.group() for centralized augroup management",
    docs = "See :h marvim.autocmd for augroup management",
  },
}

-- Check if we should show migration warnings
function M.should_warn()
  -- Check if user has opted out
  if vim.g.marvim_no_migration_warnings then
    return false
  end

  -- Only show in debug mode or if explicitly enabled
  return vim.g.marvim_debug or vim.g.marvim_show_migration_warnings
end

-- Show a deprecation warning once per session
function M.warn(pattern, replacement, context)
  if not M.should_warn() then
    return
  end

  local key = pattern .. "->" .. replacement
  if shown_warnings[key] then
    return
  end
  shown_warnings[key] = true

  local msg = string.format(
    "[MARVIM Migration] Deprecated pattern detected:\n  Old: %s\n  New: %s",
    pattern,
    replacement
  )

  if context then
    msg = msg .. "\n  Context: " .. context
  end

  -- Defer to avoid startup noise
  vim.defer_fn(function()
    vim.notify(msg, vim.log.levels.WARN, { title = "MARVIM Migration" })
  end, 100)
end

-- Scan a file for deprecated patterns
function M.scan_file(filepath)
  if not M.should_warn() then
    return
  end

  -- Skip framework files and external plugins
  if filepath:match("marvim/") or
     filepath:match("lazy/") or
     filepath:match("site/pack/") then
    return
  end

  -- Only scan user config files
  if not (filepath:match("config/") or filepath:match("utils/")) then
    return
  end

  local lines = vim.fn.readfile(filepath)
  if not lines then
    return
  end

  for line_num, line in ipairs(lines) do
    for _, detection in ipairs(patterns_to_detect) do
      if line:match(detection.pattern) then
        M.warn(
          detection.pattern,
          detection.message,
          string.format("%s:%d", filepath, line_num)
        )
      end
    end
  end
end

-- Setup autocmd to scan files as they're loaded
function M.setup()
  if not M.should_warn() then
    return
  end

  -- Create an autocmd group for migration warnings
  local group = vim.api.nvim_create_augroup("MarvimMigrationWarnings", { clear = true })

  -- Scan files on read
  vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
    group = group,
    pattern = "*.lua",
    callback = function(args)
      local filepath = vim.api.nvim_buf_get_name(args.buf)
      if filepath and filepath ~= "" then
        M.scan_file(filepath)
      end
    end,
  })

  -- Add command to check current file
  vim.api.nvim_create_user_command("MarvimCheckMigration", function()
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath and filepath ~= "" then
      local old_setting = vim.g.marvim_show_migration_warnings
      vim.g.marvim_show_migration_warnings = true
      M.scan_file(filepath)
      vim.g.marvim_show_migration_warnings = old_setting
      vim.notify("Migration check complete for " .. vim.fn.fnamemodify(filepath, ":t"))
    end
  end, { desc = "Check current file for MARVIM migration patterns" })

  -- Add command to show migration summary
  vim.api.nvim_create_user_command("MarvimMigrationSummary", function()
    local summary = {
      "MARVIM Framework Migration Summary",
      "==================================",
      "",
      "Phase 4 Migration Complete:",
      "  ✓ Simple plugin files migrated (core, editor, ui, coding)",
      "  ✓ Complex plugin files updated (which-key, completion)",
      "  ✓ Utility modules using framework (lsp, theme)",
      "  ✓ Deprecation warnings in place",
      "",
      "Deprecated Patterns to Update:",
      "  • pcall(require) → marvim.module.safe_require()",
      "  • vim.api.nvim_create_autocmd → marvim.autocmd.create()",
      "  • vim.api.nvim_create_augroup → marvim.autocmd.group()",
      "",
      "Benefits of Migration:",
      "  • Centralized error handling",
      "  • Module caching for performance",
      "  • Consistent patterns across codebase",
      "  • Event-based module communication",
      "  • Feature toggle system integration",
      "",
      "To disable migration warnings:",
      "  vim.g.marvim_no_migration_warnings = true",
      "",
      "To check a file for patterns:",
      "  :MarvimCheckMigration",
    }

    vim.notify(table.concat(summary, "\n"), vim.log.levels.INFO, {
      title = "MARVIM Migration",
      timeout = 10000,
    })
  end, { desc = "Show MARVIM migration summary" })
end

-- Migration helper functions for common conversions
M.helpers = {
  -- Convert pcall(require) to safe_require
  convert_pcall_require = function(line)
    return line:gsub("pcall%(require, [\"']([^\"']+)[\"']%)", 'M.safe_require("%1")')
            :gsub("pcall%(require%(([\"'][^\"']+[\"'])%)%)", "M.safe_require(%1)")
  end,

  -- Convert autocmd creation
  convert_autocmd = function(line)
    return line:gsub("vim%.api%.nvim_create_autocmd", "M.autocmd")
  end,

  -- Convert augroup creation
  convert_augroup = function(line)
    return line:gsub("vim%.api%.nvim_create_augroup", "M.augroup")
  end,
}

return M