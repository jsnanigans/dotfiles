local M = {}

function M.setup()
  local theme = require("utils.theme")
  local colors = theme.colors
  
  local highlights = {
    FlashBackdrop = { fg = colors.muted },
    
    FlashMatch = { bg = colors.highlight_high, fg = colors.text, bold = true },
    
    FlashCurrent = { bg = colors.pine, fg = colors.base, bold = true },
    
    FlashLabel = { bg = colors.love, fg = colors.base, bold = true },
    
    FlashPrompt = { link = "MsgArea" },
    
    FlashPromptIcon = { fg = colors.gold },
    
    FlashCursor = { reverse = true },
  }
  
  theme.set_highlights(highlights)
end

return M