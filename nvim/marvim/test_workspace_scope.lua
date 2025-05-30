-- Test script to verify workspace scope functionality
-- Run this with :luafile test_workspace_scope.lua

local function test_workspace_scope()
  print("=== Testing Workspace Scope ===\n")
  
  print("Current working directory: " .. vim.fn.getcwd())
  print("Current file: " .. (vim.fn.expand('%:p') ~= '' and vim.fn.expand('%:p') or 'No file open'))
  print("Current file's directory: " .. (vim.fn.expand('%:p:h') ~= '' and vim.fn.expand('%:p:h') or vim.fn.getcwd()))
  
  -- Test the telescope configuration by checking if the INITIAL_WORKSPACE_ROOT is stored
  local telescope_config = require("telescope")
  
  print("\n=== Scope Explanation ===")
  print("• <leader>ff - Should search in: project root based on current file location (MOST COMMON)")
  print("• <leader>fd - Should search in: " .. (vim.fn.expand('%:p:h') ~= '' and vim.fn.expand('%:p:h') or vim.fn.getcwd()) .. " (current file's directory)")
  print("• <leader>fw - Should ALWAYS search in: the directory where you opened nvim initially")
  print("• <leader>fm - Should show packages from: the initial workspace root")
  
  print("\n=== Test Scenario ===")
  print("1. Open nvim in /user/mono")
  print("2. Navigate to /user/mono/app1/src/file.js")
  print("3. Commands should behave as:")
  print("   <leader>ff → searches in /user/mono/app1/ (project root - MOST COMMON)")
  print("   <leader>fd → searches in /user/mono/app1/src/ (current file's dir)")
  print("   <leader>fw → searches in /user/mono/ (workspace root - always)")
  print("   <leader>fm → shows packages found in /user/mono/")
  
  print("\n=== Try the Commands ===")
  print("Use the new keymaps to test if they work correctly!")
end

-- Run the test
test_workspace_scope() 