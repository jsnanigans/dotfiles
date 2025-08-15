-- Test script to verify icon display in Neovim

vim.cmd("edit /tmp/test-icons.txt")

local icons = require("config.icons")

local content = {
  "=== Diagnostic Icons Test ===",
  "",
  "Error: " .. icons.diagnostics.Error,
  "Warn:  " .. icons.diagnostics.Warn,
  "Info:  " .. icons.diagnostics.Info,
  "Hint:  " .. icons.diagnostics.Hint,
  "",
  "=== Git Icons Test ===",
  "",
  "Added:    " .. icons.git.added,
  "Modified: " .. icons.git.modified,
  "Removed:  " .. icons.git.removed,
  "",
  "=== UI Icons Test ===",
  "",
  "Folder Closed: " .. icons.ui.folder_closed,
  "Folder Open:   " .. icons.ui.folder_open,
  "",
  "=== Kind Icons Test (Sample) ===",
  "",
  "Class:    " .. icons.kinds.Class,
  "Function: " .. icons.kinds.Function,
  "Variable: " .. icons.kinds.Variable,
  "Method:   " .. icons.kinds.Method,
  "",
  "If you see boxes or question marks above, the font is not configured correctly.",
  "If you see icons, everything is working!",
}

vim.api.nvim_buf_set_lines(0, 0, -1, false, content)

print("Icon test complete. Check the buffer for icon display.")
print("Also testing diagnostic signs...")

-- Set up diagnostic signs
icons.setup_diagnostic_signs()

-- Create some fake diagnostics to test
vim.diagnostic.set(vim.api.nvim_create_namespace("test"), 0, {
  {
    lnum = 2,
    col = 0,
    message = "Test error",
    severity = vim.diagnostic.severity.ERROR,
  },
  {
    lnum = 3,
    col = 0,
    message = "Test warning",
    severity = vim.diagnostic.severity.WARN,
  },
  {
    lnum = 4,
    col = 0,
    message = "Test info",
    severity = vim.diagnostic.severity.INFO,
  },
  {
    lnum = 5,
    col = 0,
    message = "Test hint",
    severity = vim.diagnostic.severity.HINT,
  },
})

print("Diagnostics added. Check the sign column for icons.")
