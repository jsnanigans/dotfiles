local M = {}

M.diagnostics = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

M.git = {
  added = " ",
  modified = " ",
  removed = " ",
}

M.kinds = {
  Array = " ",
  Boolean = "󰨙 ",
  Class = " ",
  Constant = "󰏿 ",
  Constructor = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Function = "󰊕 ",
  Interface = " ",
  Key = " ",
  Method = "󰊕 ",
  Module = " ",
  Namespace = "󰦮 ",
  Null = " ",
  Number = "󰎠 ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  String = " ",
  Struct = "󰆼 ",
  TypeParameter = " ",
  Variable = "󰀫 ",
}

M.ui = {
  folder_closed = " ",
  folder_open = " ",
  chevron_right = " ",
  chevron_down = " ",
}

M.setup_diagnostic_signs = function()
  for name, icon in pairs(M.diagnostics) do
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end
end

return M