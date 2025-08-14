-- Enhanced Git Navigation and Operations
local M = {}

-- Helper function to get hunk info at cursor
local function get_hunk_range()
  local diff = require("mini.diff")
  local buf_data = diff.get_buf_data(0)
  if not buf_data or not buf_data.hunks then
    return nil
  end

  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  for _, hunk in ipairs(buf_data.hunks) do
    if cursor_line >= hunk.buf_start and cursor_line <= hunk.buf_start + hunk.buf_count - 1 then
      return hunk
    end
  end
  return nil
end

-- Setup enhanced keymappings
function M.setup()
  local map = vim.keymap.set

  -- Check if we're in a git repository
  local function in_git_repo()
    local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()
      return result:match("true") ~= nil
    end
    return false
  end

  -- Only set up keymaps if in a git repo
  if not in_git_repo() then
    return
  end

  -- ============================================================================
  -- HUNK NAVIGATION (with counts support)
  -- ============================================================================

  -- Next/Previous hunk with count support and centering
  map("n", "]h", function()
    local count = vim.v.count1
    for _ = 1, count do
      require("mini.diff").goto_hunk("next")
    end
    vim.cmd("normal! zz") -- Center the screen
  end, { desc = "Next Git Hunk" })

  map("n", "[h", function()
    local count = vim.v.count1
    for _ = 1, count do
      require("mini.diff").goto_hunk("prev")
    end
    vim.cmd("normal! zz") -- Center the screen
  end, { desc = "Previous Git Hunk" })

  -- First/Last hunk
  map("n", "[H", function()
    require("mini.diff").goto_hunk("first")
    vim.cmd("normal! zz")
  end, { desc = "First Git Hunk" })

  map("n", "]H", function()
    require("mini.diff").goto_hunk("last")
    vim.cmd("normal! zz")
  end, { desc = "Last Git Hunk" })

  -- ============================================================================
  -- HUNK OPERATIONS
  -- ============================================================================

  -- Stage hunk (apply)
  map("n", "<leader>hs", function()
    local hunk = get_hunk_range()
    if hunk then
      vim.cmd(string.format("%d,%d!git add -p", hunk.buf_start, hunk.buf_start + hunk.buf_count - 1))
      vim.notify("Hunk staged", vim.log.levels.INFO)
    else
      vim.notify("No hunk at cursor", vim.log.levels.WARN)
    end
  end, { desc = "Stage Hunk" })

  -- Reset hunk
  map("n", "<leader>hr", function()
    require("mini.diff").reset_hunk()
    vim.notify("Hunk reset", vim.log.levels.INFO)
  end, { desc = "Reset Hunk" })

  -- Stage entire buffer
  map("n", "<leader>hS", function()
    vim.cmd("!git add %")
    vim.notify("Buffer staged", vim.log.levels.INFO)
  end, { desc = "Stage Buffer" })

  -- Reset entire buffer
  map("n", "<leader>hR", function()
    vim.cmd("!git checkout -- %")
    vim.cmd("e!") -- Reload buffer
    vim.notify("Buffer reset", vim.log.levels.INFO)
  end, { desc = "Reset Buffer" })

  -- Undo last stage
  map("n", "<leader>hu", function()
    vim.cmd("!git reset HEAD %")
    vim.notify("Unstaged changes", vim.log.levels.INFO)
  end, { desc = "Unstage Buffer" })

  -- ============================================================================
  -- HUNK PREVIEW AND INFORMATION
  -- ============================================================================

  -- Toggle diff overlay (preview all hunks)
  map("n", "<leader>hp", function()
    require("mini.diff").toggle_overlay()
  end, { desc = "Toggle Diff Overlay" })

  -- Show hunk info in floating window
  map("n", "<leader>hi", function()
    local hunk = get_hunk_range()
    if not hunk then
      vim.notify("No hunk at cursor", vim.log.levels.WARN)
      return
    end

    local lines = {
      "Hunk Information:",
      "─────────────────",
      string.format("Lines: %d-%d", hunk.buf_start, hunk.buf_start + hunk.buf_count - 1),
      string.format("Type: %s", hunk.type or "modified"),
      string.format("Size: %d lines", hunk.buf_count),
    }

    -- Create floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local width = 30
    local height = #lines
    local win = vim.api.nvim_open_win(buf, false, {
      relative = "cursor",
      row = 1,
      col = 0,
      width = width,
      height = height,
      style = "minimal",
      border = "rounded",
    })

    -- Auto-close after 3 seconds
    vim.defer_fn(function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, 3000)
  end, { desc = "Show Hunk Info" })

  -- ============================================================================
  -- VISUAL MODE OPERATIONS
  -- ============================================================================

  -- Stage selected lines
  map("v", "<leader>hs", function()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    vim.cmd(string.format("!git add -p %% --patch", start_line, end_line))
    vim.notify("Selection staged", vim.log.levels.INFO)
  end, { desc = "Stage Selection" })

  -- Reset selected lines
  map("v", "<leader>hr", function()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    vim.cmd(string.format("%d,%d!git checkout -p %%", start_line, end_line))
    vim.notify("Selection reset", vim.log.levels.INFO)
  end, { desc = "Reset Selection" })

  -- ============================================================================
  -- DIFF VIEWS
  -- ============================================================================

  -- Show diff with HEAD
  map("n", "<leader>hd", function()
    vim.cmd("!git diff %")
  end, { desc = "Diff with HEAD" })

  -- Show diff with specific commit
  map("n", "<leader>hD", function()
    local commit = vim.fn.input("Compare with commit: ", "HEAD~1")
    if commit ~= "" then
      vim.cmd("!git diff " .. commit .. " %")
    end
  end, { desc = "Diff with Commit" })

  -- Show staged changes
  map("n", "<leader>hc", function()
    vim.cmd("!git diff --cached %")
  end, { desc = "Show Staged Changes" })

  -- ============================================================================
  -- GIT BLAME
  -- ============================================================================

  -- Toggle inline blame
  map("n", "<leader>hb", function()
    local current_line = vim.fn.line(".")
    vim.cmd("!git blame -L " .. current_line .. "," .. current_line .. " %")
  end, { desc = "Blame Current Line" })

  -- Full file blame
  map("n", "<leader>hB", function()
    vim.cmd("!git blame %")
  end, { desc = "Blame File" })

  -- ============================================================================
  -- QUICK MENU (using which-key style)
  -- ============================================================================

  -- Create a git menu with <leader>g
  map("n", "<leader>g", function()
    local options = {
      {
        key = "s",
        desc = "Stage Hunk",
        action = function()
          vim.cmd("normal! <leader>hs")
        end,
      },
      {
        key = "r",
        desc = "Reset Hunk",
        action = function()
          vim.cmd("normal! <leader>hr")
        end,
      },
      {
        key = "S",
        desc = "Stage Buffer",
        action = function()
          vim.cmd("normal! <leader>hS")
        end,
      },
      {
        key = "R",
        desc = "Reset Buffer",
        action = function()
          vim.cmd("normal! <leader>hR")
        end,
      },
      {
        key = "u",
        desc = "Unstage",
        action = function()
          vim.cmd("normal! <leader>hu")
        end,
      },
      {
        key = "p",
        desc = "Preview Hunks",
        action = function()
          vim.cmd("normal! <leader>hp")
        end,
      },
      {
        key = "d",
        desc = "Diff",
        action = function()
          vim.cmd("normal! <leader>hd")
        end,
      },
      {
        key = "b",
        desc = "Blame",
        action = function()
          vim.cmd("normal! <leader>hb")
        end,
      },
      {
        key = "n",
        desc = "Next Hunk",
        action = function()
          vim.cmd("normal! ]h")
        end,
      },
      {
        key = "N",
        desc = "Prev Hunk",
        action = function()
          vim.cmd("normal! [h")
        end,
      },
      { key = "q", desc = "Quit", action = function() end },
    }

    -- Build menu text
    local lines = { "Git Actions:", "────────────" }
    for _, opt in ipairs(options) do
      table.insert(lines, string.format("  %s - %s", opt.key, opt.desc))
    end

    -- Show menu
    print(table.concat(lines, "\n"))

    -- Get user input
    local key = vim.fn.getchar()
    local char = vim.fn.nr2char(key)

    -- Execute action
    for _, opt in ipairs(options) do
      if opt.key == char then
        opt.action()
        break
      end
    end
  end, { desc = "Git Menu" })

  -- ============================================================================
  -- TEXT OBJECTS
  -- ============================================================================

  -- Inner hunk (select hunk content)
  map({ "o", "x" }, "ih", function()
    local hunk = get_hunk_range()
    if hunk then
      vim.cmd("normal! V")
      vim.api.nvim_win_set_cursor(0, { hunk.buf_start, 0 })
      vim.cmd("normal! o")
      vim.api.nvim_win_set_cursor(0, { hunk.buf_start + hunk.buf_count - 1, 0 })
    end
  end, { desc = "Inner Hunk" })

  -- Around hunk (select hunk with context)
  map({ "o", "x" }, "ah", function()
    local hunk = get_hunk_range()
    if hunk then
      local start_line = math.max(1, hunk.buf_start - 1)
      local end_line = math.min(vim.api.nvim_buf_line_count(0), hunk.buf_start + hunk.buf_count)
      vim.cmd("normal! V")
      vim.api.nvim_win_set_cursor(0, { start_line, 0 })
      vim.cmd("normal! o")
      vim.api.nvim_win_set_cursor(0, { end_line, 0 })
    end
  end, { desc = "Around Hunk" })

  -- ============================================================================
  -- CONFLICT NAVIGATION (enhanced)
  -- ============================================================================

  -- Next/Previous conflict with centering
  map("n", "]x", function()
    vim.fn.search("^<<<<<<<", "W")
    vim.cmd("normal! zz")
  end, { desc = "Next Conflict" })

  map("n", "[x", function()
    vim.fn.search("^<<<<<<<", "bW")
    vim.cmd("normal! zz")
  end, { desc = "Previous Conflict" })

  -- Quick conflict resolution
  map("n", "<leader>co", "<cmd>GitConflictChooseOurs<cr>", { desc = "Choose Ours" })
  map("n", "<leader>ct", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Choose Theirs" })
  map("n", "<leader>cb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Choose Both" })
  map("n", "<leader>cn", "<cmd>GitConflictChooseNone<cr>", { desc = "Choose None" })

  -- ============================================================================
  -- STATUS LINE INTEGRATION
  -- ============================================================================

  -- Show git status in command line
  map("n", "<leader>gs", function()
    local summary = vim.b.minidiff_summary
    if summary then
      vim.notify(
        string.format("Git: +%d ~%d -%d", summary.add or 0, summary.change or 0, summary.delete or 0),
        vim.log.levels.INFO
      )
    else
      vim.notify("No git changes", vim.log.levels.INFO)
    end
  end, { desc = "Git Status Summary" })

  -- Add helpful hints
  vim.api.nvim_create_user_command("GitKeys", function()
    local help_text = [[
Git Navigation Keys:
━━━━━━━━━━━━━━━━━━
Navigation:
  ]h/[h     - Next/Previous hunk
  ]H/[H     - Last/First hunk
  
Operations:
  <leader>hs/hr - Stage/Reset hunk
  <leader>hS/hR - Stage/Reset buffer
  <leader>hp    - Preview hunks
  <leader>hi    - Hunk info
  
Quick Menu:
  <leader>g     - Open git menu
  
Conflicts:
  ]x/[x         - Next/Previous conflict
  <leader>co/ct - Choose ours/theirs
]]
    vim.notify(help_text, vim.log.levels.INFO)
  end, { desc = "Show git keybindings help" })
end

return M
