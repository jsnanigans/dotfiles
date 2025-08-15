-- Github Dark Colorblind Theme for Neovim

local colors = {
  bg = "#0d1117",
  fg = "#c9d1d9",
  
  black = "#484f58",
  red = "#ec8e2c",
  green = "#58a6ff",
  yellow = "#d29922",
  blue = "#58a6ff",
  magenta = "#bc8cff",
  cyan = "#39c5cf",
  white = "#b1bac4",
  
  bright_black = "#6e7681",
  bright_red = "#fdac54",
  bright_green = "#79c0ff",
  bright_yellow = "#e3b341",
  bright_blue = "#79c0ff",
  bright_magenta = "#d2a8ff",
  bright_cyan = "#56d4dd",
  bright_white = "#ffffff",
  
  comment = "#6e7681",
  selection_bg = "#c9d1d9",
  selection_fg = "#0d1117",
  cursor = "#58a6ff",
  
  border = "#30363d",
  highlight = "#1f6feb",
  diff_add = "#196c2e",
  diff_delete = "#b62324",
  diff_change = "#0969da",
}

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.g.colors_name = "github-dark-colorblind"

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

hl("Normal", { fg = colors.fg, bg = colors.bg })
hl("NormalFloat", { fg = colors.fg, bg = colors.bg })
hl("Comment", { fg = colors.comment, italic = true })
hl("Constant", { fg = colors.bright_blue })
hl("String", { fg = colors.cyan })
hl("Character", { fg = colors.cyan })
hl("Number", { fg = colors.bright_blue })
hl("Boolean", { fg = colors.bright_blue })
hl("Float", { fg = colors.bright_blue })
hl("Identifier", { fg = colors.fg })
hl("Function", { fg = colors.magenta })
hl("Statement", { fg = colors.red })
hl("Conditional", { fg = colors.red })
hl("Repeat", { fg = colors.red })
hl("Label", { fg = colors.red })
hl("Operator", { fg = colors.cyan })
hl("Keyword", { fg = colors.red })
hl("Exception", { fg = colors.red })
hl("PreProc", { fg = colors.red })
hl("Include", { fg = colors.red })
hl("Define", { fg = colors.red })
hl("Macro", { fg = colors.red })
hl("PreCondit", { fg = colors.red })
hl("Type", { fg = colors.blue })
hl("StorageClass", { fg = colors.red })
hl("Structure", { fg = colors.red })
hl("Typedef", { fg = colors.red })
hl("Special", { fg = colors.cyan })
hl("SpecialChar", { fg = colors.cyan })
hl("Tag", { fg = colors.green })
hl("Delimiter", { fg = colors.fg })
hl("SpecialComment", { fg = colors.comment })
hl("Debug", { fg = colors.red })
hl("Underlined", { fg = colors.blue, underline = true })
hl("Error", { fg = colors.red, bg = colors.bg })
hl("Todo", { fg = colors.yellow, bg = colors.bg, bold = true })

hl("Cursor", { fg = colors.bg, bg = colors.cursor })
hl("CursorLine", { bg = "#161b22" })
hl("CursorLineNr", { fg = colors.bright_white })
hl("LineNr", { fg = colors.bright_black })
hl("VertSplit", { fg = colors.border })
hl("WinSeparator", { fg = colors.border })
hl("StatusLine", { fg = colors.fg, bg = "#161b22" })
hl("StatusLineNC", { fg = colors.comment, bg = "#0d1117" })
hl("TabLine", { fg = colors.comment, bg = "#161b22" })
hl("TabLineFill", { bg = "#0d1117" })
hl("TabLineSel", { fg = colors.fg, bg = colors.bg })

hl("Pmenu", { fg = colors.fg, bg = "#161b22" })
hl("PmenuSel", { fg = colors.selection_fg, bg = colors.selection_bg })
hl("PmenuSbar", { bg = "#161b22" })
hl("PmenuThumb", { bg = colors.comment })

hl("Visual", { bg = "#264466" })
hl("VisualNOS", { bg = "#264466" })
hl("Search", { fg = colors.bg, bg = colors.yellow })
hl("IncSearch", { fg = colors.bg, bg = colors.bright_yellow })
hl("CurSearch", { fg = colors.bg, bg = colors.bright_yellow })

hl("DiffAdd", { bg = colors.diff_add })
hl("DiffChange", { bg = colors.diff_change })
hl("DiffDelete", { bg = colors.diff_delete })
hl("DiffText", { bg = "#0969da", bold = true })

hl("DiagnosticError", { fg = colors.red })
hl("DiagnosticWarn", { fg = colors.yellow })
hl("DiagnosticInfo", { fg = colors.bright_blue })
hl("DiagnosticHint", { fg = colors.cyan })

hl("GitSignsAdd", { fg = colors.green })
hl("GitSignsChange", { fg = colors.blue })
hl("GitSignsDelete", { fg = colors.red })

hl("TelescopeNormal", { fg = colors.fg, bg = colors.bg })
hl("TelescopeBorder", { fg = colors.border })
hl("TelescopeSelection", { bg = "#161b22" })
hl("TelescopeSelectionCaret", { fg = colors.red })
hl("TelescopeMatching", { fg = colors.bright_blue })

hl("NeoTreeNormal", { fg = colors.fg, bg = colors.bg })
hl("NeoTreeNormalNC", { fg = colors.fg, bg = colors.bg })
hl("NeoTreeDirectoryName", { fg = colors.blue })
hl("NeoTreeDirectoryIcon", { fg = colors.blue })
hl("NeoTreeFileName", { fg = colors.fg })
hl("NeoTreeFileIcon", { fg = colors.fg })
hl("NeoTreeRootName", { fg = colors.bright_white, bold = true })
hl("NeoTreeGitAdded", { fg = colors.green })
hl("NeoTreeGitModified", { fg = colors.yellow })
hl("NeoTreeGitDeleted", { fg = colors.red })

hl("IndentBlanklineChar", { fg = "#21262d" })
hl("IndentBlanklineContextChar", { fg = colors.border })

hl("WhichKey", { fg = colors.cyan })
hl("WhichKeyGroup", { fg = colors.blue })
hl("WhichKeyDesc", { fg = colors.fg })
hl("WhichKeySeparator", { fg = colors.comment })
hl("WhichKeyFloat", { bg = colors.bg })
hl("WhichKeyValue", { fg = colors.comment })

hl("CmpItemAbbrMatch", { fg = colors.bright_blue })
hl("CmpItemAbbrMatchFuzzy", { fg = colors.bright_blue })
hl("CmpItemKindText", { fg = colors.fg })
hl("CmpItemKindMethod", { fg = colors.magenta })
hl("CmpItemKindFunction", { fg = colors.magenta })
hl("CmpItemKindConstructor", { fg = colors.magenta })
hl("CmpItemKindField", { fg = colors.blue })
hl("CmpItemKindVariable", { fg = colors.blue })
hl("CmpItemKindClass", { fg = colors.yellow })
hl("CmpItemKindInterface", { fg = colors.yellow })
hl("CmpItemKindModule", { fg = colors.yellow })
hl("CmpItemKindProperty", { fg = colors.blue })
hl("CmpItemKindUnit", { fg = colors.green })
hl("CmpItemKindValue", { fg = colors.green })
hl("CmpItemKindEnum", { fg = colors.yellow })
hl("CmpItemKindKeyword", { fg = colors.red })
hl("CmpItemKindSnippet", { fg = colors.cyan })
hl("CmpItemKindColor", { fg = colors.cyan })
hl("CmpItemKindFile", { fg = colors.fg })
hl("CmpItemKindReference", { fg = colors.magenta })
hl("CmpItemKindFolder", { fg = colors.blue })
hl("CmpItemKindEnumMember", { fg = colors.green })
hl("CmpItemKindConstant", { fg = colors.bright_blue })
hl("CmpItemKindStruct", { fg = colors.yellow })
hl("CmpItemKindEvent", { fg = colors.magenta })
hl("CmpItemKindOperator", { fg = colors.cyan })
hl("CmpItemKindTypeParameter", { fg = colors.blue })

vim.api.nvim_set_hl(0, "@variable", { fg = colors.fg })
vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.red })
vim.api.nvim_set_hl(0, "@variable.parameter", { fg = colors.fg })
vim.api.nvim_set_hl(0, "@variable.member", { fg = colors.blue })
vim.api.nvim_set_hl(0, "@constant", { fg = colors.bright_blue })
vim.api.nvim_set_hl(0, "@constant.builtin", { fg = colors.bright_blue })
vim.api.nvim_set_hl(0, "@constant.macro", { fg = colors.red })
vim.api.nvim_set_hl(0, "@module", { fg = colors.fg })
vim.api.nvim_set_hl(0, "@module.builtin", { fg = colors.red })
vim.api.nvim_set_hl(0, "@label", { fg = colors.red })
vim.api.nvim_set_hl(0, "@string", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "@string.documentation", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "@string.regexp", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "@string.escape", { fg = colors.bright_cyan })
vim.api.nvim_set_hl(0, "@string.special", { fg = colors.bright_cyan })
vim.api.nvim_set_hl(0, "@string.special.symbol", { fg = colors.fg })
vim.api.nvim_set_hl(0, "@string.special.path", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "@character", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "@character.special", { fg = colors.bright_cyan })
vim.api.nvim_set_hl(0, "@boolean", { fg = colors.bright_blue })
vim.api.nvim_set_hl(0, "@number", { fg = colors.bright_blue })
vim.api.nvim_set_hl(0, "@number.float", { fg = colors.bright_blue })
vim.api.nvim_set_hl(0, "@type", { fg = colors.blue })
vim.api.nvim_set_hl(0, "@type.builtin", { fg = colors.red })
vim.api.nvim_set_hl(0, "@type.definition", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "@attribute", { fg = colors.red })
vim.api.nvim_set_hl(0, "@attribute.builtin", { fg = colors.red })
vim.api.nvim_set_hl(0, "@property", { fg = colors.blue })
vim.api.nvim_set_hl(0, "@function", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "@function.builtin", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "@function.call", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "@function.macro", { fg = colors.red })
vim.api.nvim_set_hl(0, "@function.method", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "@function.method.call", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "@constructor", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "@operator", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "@keyword", { fg = colors.red })
vim.api.nvim_set_hl(0, "@keyword.coroutine", { fg = colors.red })
vim.api.nvim_set_hl(0, "@keyword.function", { fg = colors.red })
vim.api.nvim_set_hl(0, "@keyword.operator", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "@keyword.import", { fg = colors.red })
vim.api.nvim_set_hl(0, "@keyword.type", { fg = colors.red })
vim.api.nvim_set_hl(0, "@keyword.modifier", { fg = colors.red })
vim.api.nvim_set_hl(0, "@keyword.repeat", { fg = colors.red })
vim.api.nvim_set_hl(0, "@keyword.return", { fg = colors.red })
vim.api.nvim_set_hl(0, "@keyword.debug", { fg = colors.red })
vim.api.nvim_set_hl(0, "@keyword.exception", { fg = colors.red })
vim.api.nvim_set_hl(0, "@keyword.conditional", { fg = colors.red })
vim.api.nvim_set_hl(0, "@keyword.directive", { fg = colors.red })
vim.api.nvim_set_hl(0, "@keyword.directive.define", { fg = colors.red })
vim.api.nvim_set_hl(0, "@punctuation", { fg = colors.fg })
vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = colors.fg })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = colors.fg })
vim.api.nvim_set_hl(0, "@punctuation.special", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "@comment", { fg = colors.comment, italic = true })
vim.api.nvim_set_hl(0, "@comment.documentation", { fg = colors.comment, italic = true })
vim.api.nvim_set_hl(0, "@comment.error", { fg = colors.red })
vim.api.nvim_set_hl(0, "@comment.warning", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "@comment.todo", { fg = colors.yellow, bold = true })
vim.api.nvim_set_hl(0, "@comment.note", { fg = colors.bright_blue })
vim.api.nvim_set_hl(0, "@markup.strong", { bold = true })
vim.api.nvim_set_hl(0, "@markup.italic", { italic = true })
vim.api.nvim_set_hl(0, "@markup.strikethrough", { strikethrough = true })
vim.api.nvim_set_hl(0, "@markup.underline", { underline = true })
vim.api.nvim_set_hl(0, "@markup.heading", { fg = colors.blue, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.1", { fg = colors.blue, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.2", { fg = colors.blue, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.3", { fg = colors.blue, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.4", { fg = colors.blue, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.5", { fg = colors.blue, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.6", { fg = colors.blue, bold = true })
vim.api.nvim_set_hl(0, "@markup.quote", { fg = colors.comment })
vim.api.nvim_set_hl(0, "@markup.math", { fg = colors.blue })
vim.api.nvim_set_hl(0, "@markup.link", { fg = colors.blue, underline = true })
vim.api.nvim_set_hl(0, "@markup.link.label", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "@markup.link.url", { fg = colors.blue, underline = true })
vim.api.nvim_set_hl(0, "@markup.raw", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "@markup.raw.block", { fg = colors.cyan })
vim.api.nvim_set_hl(0, "@markup.list", { fg = colors.red })
vim.api.nvim_set_hl(0, "@markup.list.checked", { fg = colors.green })
vim.api.nvim_set_hl(0, "@markup.list.unchecked", { fg = colors.comment })
vim.api.nvim_set_hl(0, "@diff.plus", { fg = colors.green })
vim.api.nvim_set_hl(0, "@diff.minus", { fg = colors.red })
vim.api.nvim_set_hl(0, "@diff.delta", { fg = colors.yellow })
vim.api.nvim_set_hl(0, "@tag", { fg = colors.red })
vim.api.nvim_set_hl(0, "@tag.attribute", { fg = colors.blue })
vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = colors.fg })