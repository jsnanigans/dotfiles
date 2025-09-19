-- Test script for MARVIM migration layer
-- This verifies backward compatibility and proper migration

local function test_migration()
  print("Testing MARVIM Migration Layer...")
  print("=" .. string.rep("=", 50))

  -- Test 1: Framework loads correctly
  local ok, marvim = pcall(require, "marvim")
  if not ok then
    print("❌ FAILED: Could not load MARVIM framework")
    print("  Error: " .. tostring(marvim))
    return false
  end
  print("✅ PASSED: MARVIM framework loaded")

  -- Test 2: Migration module loads
  local migrate = marvim.migrate()
  if not migrate then
    print("❌ FAILED: Migration module not available")
    return false
  end
  print("✅ PASSED: Migration module loaded")

  -- Test 3: Module system works with safe_require
  local module = marvim.module()
  if not module then
    print("❌ FAILED: Module system not available")
    return false
  end

  local test_mod = module.safe_require("config.lazy")
  if test_mod then
    print("✅ PASSED: safe_require works for existing modules")
  else
    print("⚠️  WARNING: config.lazy not found (may not be loaded yet)")
  end

  -- Test 4: safe_require handles missing modules gracefully
  local missing = module.safe_require("this.module.does.not.exist")
  if missing == nil then
    print("✅ PASSED: safe_require returns nil for missing modules")
  else
    print("❌ FAILED: safe_require should return nil for missing modules")
  end

  -- Test 5: Event system works
  local event = marvim.event()
  if not event then
    print("❌ FAILED: Event system not available")
    return false
  end

  local event_fired = false
  event.on("TestEvent", function(data)
    event_fired = true
  end)
  event.emit("TestEvent", { test = true })

  if event_fired then
    print("✅ PASSED: Event system works")
  else
    print("❌ FAILED: Event system not firing events")
  end

  -- Test 6: Autocmd manager works
  local autocmd = marvim.autocmd()
  if not autocmd then
    print("❌ FAILED: Autocmd manager not available")
    return false
  end

  local group = autocmd.group("test_migration", { clear = true })
  if group then
    print("✅ PASSED: Autocmd groups work")
  else
    print("❌ FAILED: Could not create autocmd group")
  end

  -- Test 7: Toggle system works
  local toggle = marvim.toggle()
  if not toggle then
    print("❌ FAILED: Toggle system not available")
    return false
  end

  toggle.register("test_feature", {
    name = "Test Feature",
    get = function() return true end,
    set = function(state) end,
  })

  if toggle.list()["test_feature"] then
    print("✅ PASSED: Toggle system works")
  else
    print("❌ FAILED: Toggle registration failed")
  end

  -- Test 8: Plugin system works
  local plugin = marvim.plugin()
  if not plugin then
    print("❌ FAILED: Plugin system not available")
    return false
  end

  plugin.register({
    name = "test-plugin",
    type = "test",
  })

  local plugins = plugin.list()
  if plugins["test-plugin"] then
    print("✅ PASSED: Plugin registration works")
  else
    print("❌ FAILED: Plugin registration failed")
  end

  -- Test 9: Cache system works
  local cache = marvim.cache()
  if not cache then
    print("❌ FAILED: Cache system not available")
    return false
  end

  cache.set("test", "test_key", "test_value")
  local cached = cache.get("test", "test_key")
  if cached == "test_value" then
    print("✅ PASSED: Cache system works")
  else
    print("❌ FAILED: Cache get/set failed")
  end

  -- Test 10: Migration report generation
  local report = migrate.check_module("config.keymaps")
  if type(report) == "table" and report.module then
    print("✅ PASSED: Migration report generation works")
    if #report.issues > 0 then
      print("  Found " .. #report.issues .. " migration opportunities in config.keymaps")
    end
  else
    print("❌ FAILED: Migration report generation failed")
  end

  print("=" .. string.rep("=", 50))
  print("Migration Layer Test Complete!")

  return true
end

-- Run the test if called directly
if not vim then
  print("This test must be run inside Neovim")
  return
end

-- Create command to run test
vim.api.nvim_create_user_command("TestMigration", function()
  test_migration()
end, { desc = "Test MARVIM migration layer" })

-- Run test if sourced directly
if ... == nil then
  test_migration()
end

return {
  test = test_migration
}