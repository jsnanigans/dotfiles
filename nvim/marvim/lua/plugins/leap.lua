-- Leap.nvim - Specialized 2-character motions (complementing Flash.nvim)
-- Optimized for ergonomic keys and specific use cases
return {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  dependencies = {
    "tpope/vim-repeat",
  },
  config = function()
    local leap = require("leap")
    
    -- Configuration options - optimized for speed
    leap.opts.case_sensitive = false
    leap.opts.equivalence_classes = { " \t\r\n" }
    leap.opts.max_phase_one_targets = 0 -- Show labels immediately
    leap.opts.highlight_unlabeled_phase_one_targets = false
    leap.opts.max_highlighted_traversal_targets = 10
    leap.opts.safe_labels = { "s", "f", "n", "u", "t" }
    leap.opts.labels = { "a", "r", "s", "t", "d", "h", "n", "e", "i", "o" }
    leap.opts.special_keys = {
      repeat_search = '<enter>',
      next_phase_one_target = '<enter>',
      next_target = { '<enter>', ';' },
      prev_target = { '<backspace>', ',' },
      next_group = '<space>',
      prev_group = '<tab>',
      multi_accept = '<enter>',
      multi_revert = '<backspace>',
    }
    
    -- Ergonomic keybindings that complement Flash (s/S)
    -- Use keys that are comfortable but don't conflict with Flash
    
    -- Primary leap motions - use 'x' family for 2-character search
    vim.keymap.set({"n", "x", "o"}, "x", function()
      leap.leap { target_windows = { vim.api.nvim_get_current_win() } }
    end, { desc = "Leap forward (2-char)" })
    
    vim.keymap.set({"n", "x", "o"}, "X", function()
      leap.leap { 
        target_windows = { vim.api.nvim_get_current_win() },
        backward = true
      }
    end, { desc = "Leap backward (2-char)" })
    
    -- Cross-window leap for multi-window navigation
    vim.keymap.set({"n", "x", "o"}, "gx", function()
      leap.leap { target_windows = require("leap.user").get_focusable_windows() }
    end, { desc = "Leap across windows" })
    
    -- Bidirectional leap with enhanced options
    vim.keymap.set({"n", "x", "o"}, "gX", function()
      leap.leap { 
        target_windows = { vim.api.nvim_get_current_win() }, 
        opts = { safe_labels = {} },
        inclusive_op = true
      }
    end, { desc = "Leap bidirectional" })
    
    -- Specialized line-start leap (optimized for code navigation)
    vim.keymap.set({"n", "x", "o"}, "<leader>x", function()
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
              local line_content = vim.fn.getline(lnum)
              local first_non_blank = vim.fn.match(line_content, "\\S")
              if first_non_blank ~= -1 then
                table.insert(targets, { 
                  pos = { lnum, first_non_blank + 1 },
                  chars = { line_content:sub(first_non_blank + 1, first_non_blank + 1) }
                })
              end
            end
            lnum = lnum + 1
          end
        end
        
        -- Sort by distance from cursor for optimal label assignment
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
    end, { desc = "Leap to line indentation" })
    
    -- Word boundary leap for quick word navigation
    vim.keymap.set({"n", "x", "o"}, "<leader>X", function()
      local function get_word_starts(winid)
        local targets = {}
        local wininfo = vim.fn.getwininfo(winid)[1]
        local cur_line = vim.fn.line(".")
        local cur_col = vim.fn.col(".")
        
        for lnum = wininfo.topline, wininfo.botline do
          local line_content = vim.fn.getline(lnum)
          local col = 1
          
          while col <= #line_content do
            local char = line_content:sub(col, col)
            if char:match("%w") and (col == 1 or not line_content:sub(col-1, col-1):match("%w")) then
              if not (lnum == cur_line and col == cur_col) then
                table.insert(targets, { 
                  pos = { lnum, col },
                  chars = { char }
                })
              end
            end
            col = col + 1
          end
        end
        
        return targets
      end
      
      local winid = vim.api.nvim_get_current_win()
      leap.leap {
        target_windows = { winid },
        targets = get_word_starts(winid),
      }
    end, { desc = "Leap to word starts" })
    
    -- Enhanced highlighting for better visibility
    vim.api.nvim_set_hl(0, "LeapMatch", { 
      fg = "#7aa2f7", 
      bg = "#1a1b26",
      bold = true, 
      nocombine = true 
    })
    
    vim.api.nvim_set_hl(0, "LeapLabel", { 
      fg = "#1a1b26", 
      bg = "#9ece6a", 
      bold = true, 
      nocombine = true 
    })
    
    vim.api.nvim_set_hl(0, "LeapBackdrop", { 
      fg = "#414868",
      nocombine = true
    })
    
    -- Primary phase highlighting
    vim.api.nvim_set_hl(0, "LeapLabelPrimary", {
      fg = "#1a1b26",
      bg = "#f7768e",
      bold = true,
      nocombine = true
    })
    
    vim.api.nvim_set_hl(0, "LeapLabelSecondary", {
      fg = "#1a1b26", 
      bg = "#e0af68",
      bold = true,
      nocombine = true
    })
  end,
} 