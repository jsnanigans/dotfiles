-- Debug script to test icon rendering
-- Run inside Neovim with :source ~/dotfiles/nvim/debug-icons.lua

local function test_icons()
  print("\n=== Testing Icon Display ===\n")

  -- Test basic icons
  local test_icons = {
    ["Error"] = " ",
    ["Warning"] = " ",
    ["Info"] = " ",
    ["Hint"] = " ",
    ["Folder"] = " ",
    ["Git"] = " ",
  }

  for name, icon in pairs(test_icons) do
    print(string.format("%s: '%s' (length: %d)", name, icon, #icon))
  end

  -- Check if nvim-web-devicons is loaded
  local ok_devicons, devicons = pcall(require, "nvim-web-devicons")
  if ok_devicons then
    print("\n✓ nvim-web-devicons is loaded")
    local icon, color = devicons.get_icon("test.lua", "lua")
    print(string.format("Lua file icon: '%s' color: %s", icon or "none", color or "none"))
  else
    print("\n✗ nvim-web-devicons NOT loaded")
  end

  -- Check if Trouble is loaded
  local ok_trouble, trouble = pcall(require, "trouble")
  if ok_trouble then
    print("\n✓ Trouble is loaded")
  else
    print("\n✗ Trouble NOT loaded: " .. tostring(trouble))
  end

  -- Check if config.icons is available
  local ok_icons, icons = pcall(require, "config.icons")
  if ok_icons then
    print("\n✓ config.icons module loaded")
    print("Error icon from config: '" .. icons.diagnostics.Error .. "'")
  else
    print("\n✗ config.icons NOT loaded: " .. tostring(icons))
  end

  -- Check diagnostic signs
  print("\n=== Diagnostic Signs ===")
  local signs = vim.fn.sign_getdefined()
  for _, sign in ipairs(signs) do
    if sign.name:match("^DiagnosticSign") then
      print(string.format("%s: '%s'", sign.name, sign.text or "no text"))
    end
  end

  -- Check encoding
  print("\n=== Environment ===")
  print("Encoding: " .. vim.o.encoding)
  print("Termguicolors: " .. tostring(vim.o.termguicolors))
  print("Has GUI: " .. tostring(vim.fn.has("gui_running") == 1))

  -- Test rendering in a buffer
  vim.cmd("new")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {
    "Test Icons:",
    " Error",
    " Warning",
    " Info",
    " Hint",
  })
  print("\n✓ Created test buffer with icons")
end

test_icons()
