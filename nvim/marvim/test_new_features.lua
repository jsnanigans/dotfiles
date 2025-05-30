-- Test script for new monorepo features
-- Run this with :luafile test_new_features.lua

local function test_new_features()
  print("=== Testing New Features ===\n")
  
  -- Test project utilities
  local project_utils = require("config.project-utils")
  
  print("1. Testing Project Root Detection:")
  local project_root = project_utils.find_project_root()
  local project_name = project_utils.get_project_name()
  print("   Project root: " .. project_root)
  print("   Project name: " .. project_name)
  
  print("\n2. Testing Monorepo Detection:")
  local is_monorepo = project_utils.is_monorepo()
  local packages = project_utils.find_monorepo_packages()
  print("   Is monorepo: " .. (is_monorepo and "Yes" or "No"))
  print("   Packages found: " .. #packages)
  
  if #packages > 0 then
    print("   Package list:")
    for i, pkg in ipairs(packages) do
      if i <= 3 then -- Show first 3
        print("     - " .. pkg.name .. " (" .. pkg.relative .. ")")
      elseif i == 4 then
        print("     - ... and " .. (#packages - 3) .. " more")
        break
      end
    end
  end
  
  print("\n3. Available Key Mappings:")
  print("   Project-Aware Search:")
  print("     <leader>ff - Find files in project (most common)")
  print("     <leader>fd - Find files in current dir")
  print("     <leader>fw - Find files in workspace root (where nvim opened)")
  print("     <leader>fm - Find files in monorepo package")
  
  print("   String Search:")
  print("     <leader>fs - Find string in project")
  print("     <leader>fc - Find string under cursor in project")
  print("     <leader>fS - Find string in current dir")
  print("     <leader>fW - Find string in workspace root")
  print("     <leader>fM - Find string in monorepo package")
  
  print("   Project Management:")
  print("     <leader>pc - Change to project root")
  print("     <leader>pi - Show project info")
  
  print("\n=== Test Complete ===")
end

test_new_features() 