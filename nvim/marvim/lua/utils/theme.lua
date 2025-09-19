-- Theme Utility Module
-- Migrated to use MARVIM framework for better error handling and consistency
-- This module will be gradually moved to the framework's theming system

local marvim = require("marvim.plugin_helper")
local M = {}

-- ============================================================================
-- THEME COLOR PALETTES
-- ============================================================================

-- Get the current theme from .current-theme file or default
local function get_current_theme()
  local theme_file = vim.fn.expand("~/dotfiles/theme/.current-theme")
  if vim.fn.filereadable(theme_file) == 1 then
    local lines = vim.fn.readfile(theme_file)
    if lines and #lines > 0 then
      return lines[1]
    end
  end
  -- Default to github-dark-colorblind
  return "github-dark-colorblind"
end

-- Get the current background and variant
local function get_variant()
  local theme = get_current_theme()
  if theme == "github-dark-colorblind" then
    return "github-dark-colorblind"
  end
  -- Default to dark for other themes
  return "dark"
end

-- Color palettes for different themes
local palettes = {
  ["github-dark-colorblind"] = {
    -- Base colors
    base = "#0d1117",
    surface = "#161b22",
    overlay = "#1f2428",
    highlight_low = "#161b22",
    highlight_med = "#30363d",
    highlight_high = "#484f58",

    -- Text colors
    muted = "#6e7681",
    subtle = "#6e7681",
    text = "#c9d1d9",

    -- Accent colors (colorblind-friendly mapping)
    love = "#ec8e2c",     -- red (orange for colorblind)
    gold = "#d29922",     -- yellow
    rose = "#bc8cff",     -- magenta
    pine = "#58a6ff",     -- blue (used for green in colorblind)
    foam = "#39c5cf",     -- cyan
    iris = "#bc8cff",     -- magenta
    
    -- Additional colors
    green = "#58a6ff",      -- Using blue for green (colorblind)
    bright_red = "#fdac54", -- Bright orange
    bright_green = "#79c0ff", -- Bright blue
    bright_yellow = "#e3b341",
    bright_blue = "#79c0ff",
    bright_magenta = "#d2a8ff",
    bright_cyan = "#56d4dd",
  },
  dark = {
    -- Flexoki Dark colors (fallback)
    base = "#100f0f",
    surface = "#575653",
    overlay = "#575653",
    highlight_low = "#575653",
    highlight_med = "#878580",
    highlight_high = "#878580",

    -- Text colors
    muted = "#878580",
    subtle = "#878580",
    text = "#cecdc3",

    -- Accent colors (mapped from flexoki colors)
    love = "#d14d41",     -- red
    gold = "#d0a215",     -- yellow
    rose = "#ce5d97",     -- magenta
    pine = "#4385be",     -- blue
    foam = "#3aa99f",     -- cyan
    iris = "#ce5d97",     -- magenta
    
    -- Additional flexoki colors
    green = "#879a39",
    bright_red = "#af3029",
    bright_green = "#66800b",
    bright_yellow = "#ad8301",
    bright_blue = "#205ea6",
    bright_magenta = "#a02f6f",
    bright_cyan = "#24837b",
  },
  moon = {
    -- Fallback to dark theme
    base = "#100f0f",
    surface = "#575653",
    overlay = "#575653",
    highlight_low = "#575653",
    highlight_med = "#878580",
    highlight_high = "#878580",

    -- Text colors
    muted = "#878580",
    subtle = "#878580",
    text = "#cecdc3",

    -- Accent colors (same as dark for consistency)
    love = "#d14d41",
    gold = "#d0a215",
    rose = "#ce5d97",
    pine = "#4385be",
    foam = "#3aa99f",
    iris = "#ce5d97",
  },
  dawn = {
    -- Fallback to dark theme (flexoki doesn't have a light variant)
    base = "#100f0f",
    surface = "#575653",
    overlay = "#575653",
    highlight_low = "#575653",
    highlight_med = "#878580",
    highlight_high = "#878580",

    -- Text colors
    muted = "#878580",
    subtle = "#878580",
    text = "#cecdc3",

    -- Accent colors
    love = "#d14d41",
    gold = "#d0a215",
    rose = "#ce5d97",
    pine = "#4385be",
    foam = "#3aa99f",
    iris = "#ce5d97",
  },
}

-- Get current variant colors
M.colors = palettes[get_variant()]

-- ============================================================================
-- SEMANTIC COLOR MAPPING
-- ============================================================================

M.semantic = {
  bg_primary = M.colors.base,
  bg_secondary = M.colors.surface,
  bg_tertiary = M.colors.overlay,
  bg_float = M.colors.surface,
  bg_popup = M.colors.overlay,
  bg_sidebar = M.colors.surface,
  bg_statusline = M.colors.surface,

  fg_primary = M.colors.text,
  fg_secondary = M.colors.subtle,
  fg_muted = M.colors.muted,
  fg_disabled = M.colors.muted,

  hover = M.colors.highlight_med,
  active = M.colors.highlight_high,
  selected = M.colors.highlight_high,
  focus = M.colors.iris,

  border = M.colors.highlight_med,
  border_focus = M.colors.iris,
  border_active = M.colors.foam,

  error = M.colors.love,
  warning = M.colors.gold,
  info = M.colors.foam,
  success = M.colors.pine,
  hint = M.colors.iris,

  keyword = M.colors.pine,
  function_name = M.colors.rose,
  string = M.colors.gold,
  number = M.colors.iris,
  boolean = M.colors.love,
  comment = M.colors.muted,
  variable = M.colors.text,
  constant = M.colors.foam,
  type = M.colors.iris,
  class = M.colors.foam,
  method = M.colors.rose,
  property = M.colors.iris,

  git_add = M.colors.pine,
  git_change = M.colors.gold,
  git_delete = M.colors.love,

  diff_add = M.colors.pine,
  diff_change = M.colors.gold,
  diff_delete = M.colors.love,
  diff_text = M.colors.foam,
}

-- ============================================================================
-- HIGHLIGHT UTILITIES
-- ============================================================================

function M.highlight(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.set_highlights(highlights)
  for group, opts in pairs(highlights) do
    M.highlight(group, opts)
  end
end

-- ============================================================================
-- COLOR MANIPULATION
-- ============================================================================

function M.with_alpha(color, alpha)
  if alpha == nil then
    return color
  end
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)
  return string.format("rgba(%d, %d, %d, %.2f)", r, g, b, alpha)
end

function M.darken(color, percent)
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)
  r = math.floor(r * (1 - percent))
  g = math.floor(g * (1 - percent))
  b = math.floor(b * (1 - percent))
  return string.format("#%02x%02x%02x", r, g, b)
end

function M.lighten(color, percent)
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)
  r = math.floor(r + (255 - r) * percent)
  g = math.floor(g + (255 - g) * percent)
  b = math.floor(b + (255 - b) * percent)
  return string.format("#%02x%02x%02x", r, g, b)
end

-- ============================================================================
-- UI HIGHLIGHTS
-- ============================================================================

M.ui_highlights = {
  NormalFloat = { fg = M.semantic.fg_primary, bg = "NONE" },
  FloatBorder = { fg = M.semantic.border, bg = "NONE" },
  FloatTitle = { fg = M.semantic.fg_primary, bg = "NONE", bold = true },

  Pmenu = { fg = M.semantic.fg_primary, bg = M.semantic.bg_popup },
  PmenuExtra = { fg = M.semantic.fg_secondary, bg = M.semantic.bg_popup },
  PmenuExtraSel = { fg = M.semantic.fg_primary, bg = M.semantic.selected },
  PmenuKind = { fg = M.semantic.info, bg = M.semantic.bg_popup },
  PmenuKindSel = { fg = M.semantic.info, bg = M.semantic.selected },
  PmenuSbar = { bg = M.semantic.bg_popup },
  PmenuSel = { fg = M.semantic.fg_primary, bg = M.semantic.selected },
  PmenuThumb = { bg = M.semantic.border },

  LspInfoBorder = { fg = M.semantic.border, bg = "NONE" },
  LspSignatureActiveParameter = { fg = M.semantic.focus, bold = true },

  DiagnosticError = { fg = M.semantic.error },
  DiagnosticWarn = { fg = M.semantic.warning },
  DiagnosticInfo = { fg = M.semantic.info },
  DiagnosticHint = { fg = M.semantic.hint },
  DiagnosticOk = { fg = M.semantic.success },

  LspReferenceText = { bg = M.semantic.highlight_low },
  LspReferenceRead = { bg = M.semantic.highlight_low },
  LspReferenceWrite = { bg = M.semantic.highlight_med },

  WinBar = { fg = M.semantic.fg_secondary, bg = M.semantic.bg_statusline },
  WinBarNC = { fg = M.semantic.fg_muted, bg = M.semantic.bg_statusline },

  -- Line numbers with better contrast
  LineNr = { fg = M.colors.subtle }, -- Use flexoki subtle color
  LineNrAbove = { fg = M.colors.subtle },
  LineNrBelow = { fg = M.colors.subtle },
  CursorLineNr = { fg = M.colors.text, bold = true },

  -- Snacks picker highlights for better contrast
  SnacksPickerMatch = { fg = M.colors.iris, bold = true },
  SnacksPickerMatchBorder = { fg = M.colors.foam },
  SnacksPickerNormal = { fg = M.colors.text },
  SnacksPickerFaint = { fg = M.colors.subtle }, -- Use flexoki subtle color
  SnacksPickerComment = { fg = M.colors.subtle }, -- Use flexoki subtle color
  SnacksPickerSelection = { bg = M.colors.highlight_high, fg = M.colors.text },
  SnacksPickerSelectionBorder = { bg = M.colors.highlight_high, fg = M.colors.foam },

  -- Telescope-like highlights that snacks might also use
  TelescopeNormal = { fg = M.colors.text },
  TelescopePreviewLine = { bg = M.colors.highlight_high },
  TelescopePreviewMatch = { fg = M.colors.iris, bold = true },
  TelescopeMatching = { fg = M.colors.iris, bold = true },
  TelescopeSelection = { bg = M.colors.highlight_high, fg = M.colors.text },
  TelescopeSelectionCaret = { fg = M.colors.foam },

  -- General high-contrast improvements
  Comment = { fg = M.colors.muted, italic = true }, -- Uses flexoki muted color
  NonText = { fg = M.colors.muted }, -- Use flexoki muted color
  SpecialKey = { fg = M.colors.muted },
  Conceal = { fg = M.colors.muted },
  Directory = { fg = M.colors.foam, bold = true },
  IncSearch = { bg = M.colors.gold, fg = M.colors.base, bold = true },
  Search = { bg = M.colors.highlight_high, fg = M.colors.text },
  MoreMsg = { fg = M.colors.pine, bold = true },
  Question = { fg = M.colors.foam, bold = true },
  Title = { fg = M.colors.iris, bold = true },

  -- Command line completion highlights
  WildMenu = { fg = M.colors.text, bg = M.colors.highlight_high, bold = true },
  StatusLine = { fg = M.colors.text, bg = M.colors.surface },
  StatusLineNC = { fg = M.colors.subtle, bg = M.colors.surface },
}

-- ============================================================================
-- SETUP FUNCTION
-- ============================================================================

function M.setup()
  vim.schedule(function()
    M.set_highlights(M.ui_highlights)
  end)

  marvim.autocmd("ColorScheme", {
    callback = function()
      if
        vim.g.colors_name == "github-dark-colorblind"
        or vim.g.colors_name == "flexoki-dark"
        or vim.g.colors_name == "flexoki"
      then
        vim.schedule(function()
          M.set_highlights(M.ui_highlights)
        end)
      end
    end,
  })
end

return M
