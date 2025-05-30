-- TypeScript LSP Test Script
-- Run this with :luafile test_typescript_lsp.lua in a TypeScript file

local function test_typescript_lsp()
  print("=== TypeScript LSP Diagnostics ===\n")
  
  -- Check if we're in a TypeScript file
  local filetype = vim.bo.filetype
  local typescript_types = {
    "typescript", "typescriptreact", "javascript", "javascriptreact"
  }
  
  local is_typescript = false
  for _, ft in ipairs(typescript_types) do
    if filetype == ft then
      is_typescript = true
      break
    end
  end
  
  print("Current file type: " .. filetype)
  print("Is TypeScript file: " .. (is_typescript and "Yes" or "No"))
  
  if not is_typescript then
    print("\n⚠️  Please run this test in a TypeScript/JavaScript file")
    return
  end
  
  -- Check LSP clients
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  print("\nAttached LSP clients: " .. #clients)
  
  if #clients == 0 then
    print("❌ No LSP clients attached to current buffer")
    print("\nTroubleshooting steps:")
    print("1. Make sure you're in a project with package.json or tsconfig.json")
    print("2. Check :Mason to see if typescript-language-server is installed")
    print("3. Run :LspInfo for more details")
    print("4. Try :LspRestart to restart LSP servers")
    return
  end
  
  -- Check for TypeScript LSP specifically
  local ts_client = nil
  local eslint_client = nil
  
  for _, client in ipairs(clients) do
    print("- " .. client.name .. " (id: " .. client.id .. ")")
    if client.name == "ts_ls" then
      ts_client = client
    elseif client.name == "eslint" then
      eslint_client = client
    end
  end
  
  print("\nTypeScript LSP status:")
  if ts_client then
    print("✅ ts_ls is running")
    print("   Root directory: " .. (ts_client.config.root_dir or "unknown"))
    print("   Workspace folders: " .. vim.inspect(ts_client.workspace_folders or {}))
  else
    print("❌ ts_ls is not running")
  end
  
  print("\nESLint LSP status:")
  if eslint_client then
    print("✅ eslint is running")
  else
    print("⚠️  eslint is not running (this is optional)")
  end
  
  -- Check capabilities
  if ts_client then
    print("\nTypeScript LSP capabilities:")
    local caps = ts_client.server_capabilities
    print("- Hover: " .. (caps.hoverProvider and "✅" or "❌"))
    print("- Completion: " .. (caps.completionProvider and "✅" or "❌"))
    print("- Go to definition: " .. (caps.definitionProvider and "✅" or "❌"))
    print("- References: " .. (caps.referencesProvider and "✅" or "❌"))
    print("- Rename: " .. (caps.renameProvider and "✅" or "❌"))
    print("- Formatting: " .. (caps.documentFormattingProvider and "✅ (disabled)" or "❌"))
    print("- Code actions: " .. (caps.codeActionProvider and "✅" or "❌"))
  end
  
  -- Check project structure
  print("\nProject structure check:")
  local project_files = {
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".prettierrc",
    ".eslintrc.js",
    ".eslintrc.json"
  }
  
  for _, file in ipairs(project_files) do
    local found = vim.fn.findfile(file, ".;") ~= ""
    print("- " .. file .. ": " .. (found and "✅" or "❌"))
  end
  
  -- Check if Node.js is available
  print("\nEnvironment check:")
  local node_version = vim.fn.system("node --version 2>/dev/null"):gsub("\n", "")
  if node_version ~= "" then
    print("- Node.js: ✅ " .. node_version)
  else
    print("- Node.js: ❌ Not found")
  end
  
  local npm_version = vim.fn.system("npm --version 2>/dev/null"):gsub("\n", "")
  if npm_version ~= "" then
    print("- npm: ✅ " .. npm_version)
  else
    print("- npm: ❌ Not found")
  end
  
  print("\n=== Test Complete ===")
  print("If TypeScript LSP is not working:")
  print("1. Open a TypeScript file in a project with package.json")
  print("2. Run :Mason and install typescript-language-server")
  print("3. Run :LspRestart")
  print("4. Use <leader>ld for quick diagnostics")
end

-- Run the test
test_typescript_lsp() 