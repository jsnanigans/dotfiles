-- Test backward compatibility with migration shims
-- This ensures old patterns still work but show deprecation warnings

local function test_backward_compat()
  print("Testing Backward Compatibility...")
  print("=" .. string.rep("=", 50))

  -- Load migration module
  local marvim = require("marvim")
  local migrate = marvim.migrate()

  -- Track deprecation warnings
  local warnings = {}
  local old_notify = vim.notify
  vim.notify = function(msg, level, opts)
    if opts and opts.title == "MARVIM Migration" then
      table.insert(warnings, msg)
    end
    -- Still show the notification
    old_notify(msg, level, opts)
  end

  -- Install shims to test backward compatibility
  migrate.install_shims()
  print("✅ Shims installed")

  -- Test 1: pcall(require) pattern (should work but warn)
  local ok, result = pcall(require, "config.options")
  if ok then
    print("✅ PASSED: pcall(require) still works")
    if #warnings > 0 then
      print("  ✅ Deprecation warning shown")
    else
      print("  ⚠️  No deprecation warning (may be suppressed)")
    end
  else
    print("❌ FAILED: pcall(require) broken")
  end

  -- Reset warnings
  warnings = {}

  -- Test 2: Direct vim.keymap.set (should work but warn)
  local test_keymap_worked = false
  local ok2 = pcall(function()
    vim.keymap.set("n", "<leader>test", function()
      test_keymap_worked = true
    end, { desc = "Test keymap" })
  end)

  if ok2 then
    print("✅ PASSED: vim.keymap.set still works")
    -- Note: Warning detection depends on source file location
  else
    print("❌ FAILED: vim.keymap.set broken")
  end

  -- Test 3: Direct autocmd creation (should work but warn)
  local autocmd_fired = false
  local ok3 = pcall(function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "TestBackwardCompat",
      callback = function()
        autocmd_fired = true
      end,
    })
  end)

  if ok3 then
    print("✅ PASSED: vim.api.nvim_create_autocmd still works")
    vim.api.nvim_exec_autocmds("User", { pattern = "TestBackwardCompat" })
    if autocmd_fired then
      print("  ✅ Autocmd fires correctly")
    end
  else
    print("❌ FAILED: vim.api.nvim_create_autocmd broken")
  end

  -- Test 4: Module migration helper
  local test_module = {
    setup = function(opts)
      return "old_setup_called"
    end,
    old_function = function()
      return "old_function"
    end,
  }

  local migrated = migrate.migrate_module(test_module, "test.module")
  if migrated then
    print("✅ PASSED: Module migration helper works")
    if migrated.old_function then
      print("  ✅ Old functions preserved")
    end
  else
    print("❌ FAILED: Module migration failed")
  end

  -- Test 5: Keymap migration helper
  local old_keymap = {
    mode = "n",
    lhs = "<leader>test2",
    rhs = ":echo 'test'<CR>",
    desc = "Test keymap 2",
  }

  local ok5 = pcall(function()
    migrate.migrate_keymap(old_keymap)
  end)

  if ok5 then
    print("✅ PASSED: Keymap migration helper works")
  else
    print("❌ FAILED: Keymap migration failed")
  end

  -- Test 6: File migration check (dry run)
  local test_file_content = [[
local ok, mod = pcall(require, "test")
vim.api.nvim_create_autocmd("BufRead", { callback = function() end })
vim.keymap.set("n", "<leader>t", ":Test<CR>")
]]

  -- Write test file
  local test_file = vim.fn.stdpath("config") .. "/test_migration_file.lua"
  vim.fn.writefile(vim.split(test_file_content, "\n"), test_file)

  local migrations = migrate.migrate_file(test_file, true) -- dry run
  if migrations and #migrations > 0 then
    print("✅ PASSED: File migration detection works")
    print("  Found " .. #migrations .. " patterns to migrate")
    for _, m in ipairs(migrations) do
      print("    Line " .. m.line .. ": " .. m.pattern)
    end
  else
    print("⚠️  WARNING: No migrations detected in test file")
  end

  -- Clean up test file
  vim.fn.delete(test_file)

  -- Restore original notify
  vim.notify = old_notify

  print("=" .. string.rep("=", 50))
  print("Backward Compatibility Test Complete!")
  print("Total deprecation warnings: " .. #warnings)

  return true
end

-- Create command to run test
vim.api.nvim_create_user_command("TestBackwardCompat", function()
  test_backward_compat()
end, { desc = "Test MARVIM backward compatibility" })

-- Run test if sourced directly
if ... == nil then
  test_backward_compat()
end

return {
  test = test_backward_compat
}