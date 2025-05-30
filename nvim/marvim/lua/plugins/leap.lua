-- Leap.nvim - Neovim's answer to the mouse 🦘
-- General-purpose motion plugin with 2-character search patterns
return {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  dependencies = {
    "tpope/vim-repeat",
  },
  config = function()
    local leap = require("leap")
    
    -- Configuration options
    leap.opts.case_sensitive = false
    leap.opts.equivalence_classes = { " \t\r\n" }
    
    -- Use different keys than Flash.nvim to avoid conflicts
    -- Flash uses 's' and 'S', so we'll use different keys for leap
    vim.keymap.set({"n", "x", "o"}, "gs", function()
      leap.leap { target_windows = { vim.api.nvim_get_current_win() } }
    end, { desc = "Leap forward" })
    
    vim.keymap.set({"n", "x", "o"}, "gS", function()
      leap.leap { target_windows = require("leap.user").get_focusable_windows() }
    end, { desc = "Leap in all windows" })
    
    -- Bidirectional leap (search in both directions)
    vim.keymap.set({"n", "x", "o"}, "gx", function()
      leap.leap { target_windows = { vim.api.nvim_get_current_win() }, opts = { safe_labels = {} } }
    end, { desc = "Leap bidirectional" })
    
    -- Leap to line starts
    vim.keymap.set({"n", "x", "o"}, "gl", function()
      local function get_line_starts(winid)
        local wininfo = vim.fn.getwininfo(winid)[1]
        local cur_line = vim.fn.line(".")
        local targets = {}
        local lnum = wininfo.topline
        
        while lnum <= wininfo.botline do
          local fold_end = vim.fn.foldclosedend(lnum)
          if fold_end ~= -1 then
            lnum = fold_end + 1
          else
            if lnum ~= cur_line then
              table.insert(targets, { pos = { lnum, 1 } })
            end
            lnum = lnum + 1
          end
        end
        
        -- Sort by distance from cursor
        local cur_screen_row = vim.fn.screenpos(winid, cur_line, 1)["row"]
        table.sort(targets, function(t1, t2)
          local t1_screen_row = vim.fn.screenpos(winid, t1.pos[1], t1.pos[2])["row"]
          local t2_screen_row = vim.fn.screenpos(winid, t2.pos[1], t2.pos[2])["row"]
          return math.abs(cur_screen_row - t1_screen_row) < math.abs(cur_screen_row - t2_screen_row)
        end)
        
        return targets
      end
      
      local winid = vim.api.nvim_get_current_win()
      leap.leap {
        target_windows = { winid },
        targets = get_line_starts(winid),
      }
    end, { desc = "Leap to line start" })
    
    -- Custom highlighting
    vim.api.nvim_set_hl(0, "LeapMatch", { 
      fg = "#ff9e64", 
      bold = true, 
      nocombine = true 
    })
    
    vim.api.nvim_set_hl(0, "LeapLabel", { 
      fg = "#ff007c", 
      bold = true, 
      nocombine = true 
    })
    
    vim.api.nvim_set_hl(0, "LeapBackdrop", { 
      link = "Comment" 
    })
  end,
} 