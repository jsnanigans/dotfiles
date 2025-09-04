local M = {}

function M.setup()
  local pickers = require("utils.git.pickers")
  pickers.setup()
  
  local map = vim.keymap.set

  map("n", "<leader>gd", function()
    pickers.files_vs_branch()
  end, { desc = "Git diff files (vs release)" })

  map("n", "<leader>gD", function()
    vim.ui.input({ prompt = "Branch to compare: ", default = "main" }, function(branch)
      if branch then
        pickers.files_vs_branch(branch)
      end
    end)
  end, { desc = "Git diff files (vs custom branch)" })

  map("n", "<leader>gh", function()
    pickers.hunks_picker()
  end, { desc = "Git hunks picker" })

  map("n", "<leader>gC", function()
    pickers.commit()
  end, { desc = "Git commit" })

  map("n", "<leader>gA", function()
    pickers.stage_all()
  end, { desc = "Stage all changes" })

  map("n", "<leader>gU", function()
    pickers.unstage_all()
  end, { desc = "Unstage all changes" })

  map("n", "<leader>gb", function()
    vim.cmd("!git blame -L " .. vim.fn.line(".") .. "," .. vim.fn.line(".") .. " %")
  end, { desc = "Git blame line" })

  map("n", "<leader>gB", function()
    vim.cmd("!git blame %")
  end, { desc = "Git blame buffer" })

  map("n", "<leader>go", function()
    local snacks = require("snacks")
    if snacks and snacks.gitbrowse then
      snacks.gitbrowse()
    else
      vim.notify("Snacks gitbrowse not available", vim.log.levels.WARN)
    end
  end, { desc = "Open in browser" })

  map("n", "<leader>gl", function()
    local snacks = require("snacks")
    if snacks and snacks.lazygit then
      snacks.lazygit()
    else
      vim.notify("Snacks lazygit not available", vim.log.levels.WARN)
    end
  end, { desc = "LazyGit" })

  map("n", "<leader>gL", function()
    local snacks = require("snacks")
    if snacks and snacks.lazygit then
      snacks.lazygit.log()
    else
      vim.notify("Snacks lazygit not available", vim.log.levels.WARN)
    end
  end, { desc = "LazyGit log" })

  map("n", "<leader>gf", function()
    local snacks = require("snacks")
    if snacks and snacks.lazygit then
      snacks.lazygit.log_file()
    else
      vim.notify("Snacks lazygit not available", vim.log.levels.WARN)
    end
  end, { desc = "LazyGit file history" })

  map("n", "ghs", function()
    local buf = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = cursor[1]
    
    local hunks = require("mini.diff").get_buf_data(buf)
    if not hunks or not hunks.hunks then
      vim.notify("No hunks in current buffer", vim.log.levels.INFO)
      return
    end

    for _, hunk in ipairs(hunks.hunks) do
      if line >= hunk.buf_start and line < hunk.buf_start + hunk.buf_count then
        local lines_to_stage = {}
        for i = hunk.buf_start, hunk.buf_start + hunk.buf_count - 1 do
          table.insert(lines_to_stage, vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1])
        end
        
        local tempfile = vim.fn.tempname()
        vim.fn.writefile(lines_to_stage, tempfile)
        
        local filename = vim.api.nvim_buf_get_name(buf)
        local cmd = string.format("git diff --no-index --no-prefix %s %s | git apply --cached", 
          vim.fn.shellescape(filename), vim.fn.shellescape(tempfile))
        vim.fn.system(cmd)
        vim.fn.delete(tempfile)
        
        vim.notify("Hunk staged", vim.log.levels.INFO)
        return
      end
    end
    
    vim.notify("No hunk at cursor position", vim.log.levels.INFO)
  end, { desc = "Stage hunk" })

  map("n", "ghu", function()
    local buf = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = cursor[1]
    
    local filename = vim.api.nvim_buf_get_name(buf)
    local cmd = string.format("git diff --cached %s | git apply --reverse --cached", 
      vim.fn.shellescape(filename))
    local output = vim.fn.system(cmd)
    
    if vim.v.shell_error == 0 then
      vim.notify("Hunk unstaged", vim.log.levels.INFO)
    else
      vim.notify("Failed to unstage hunk", vim.log.levels.ERROR)
    end
  end, { desc = "Unstage hunk" })

  map("n", "ghr", function()
    require("mini.diff").reset_hunk()
  end, { desc = "Reset hunk" })

  map("n", "]h", function()
    require("mini.diff").goto_hunk("next")
  end, { desc = "Next hunk" })

  map("n", "[h", function()
    require("mini.diff").goto_hunk("prev")
  end, { desc = "Previous hunk" })

  map("n", "]H", function()
    require("mini.diff").goto_hunk("last")
  end, { desc = "Last hunk" })

  map("n", "[H", function()
    require("mini.diff").goto_hunk("first")
  end, { desc = "First hunk" })

  map({ "o", "x" }, "ih", function()
    require("mini.diff").textobject()
  end, { desc = "Inner hunk" })

  map("n", "<leader>g?", function()
    local help_text = [[
Git Keybindings:

Navigation:
  [h/]h     - Previous/Next hunk
  [H/]H     - First/Last hunk
  ih        - Inner hunk (text object)

Staging:
  ghs       - Stage hunk
  ghu       - Unstage hunk
  ghr       - Reset hunk
  <leader>gA - Stage all changes
  <leader>gU - Unstage all changes

Pickers:
  <leader>gd - Files changed vs release branch
  <leader>gD - Files changed vs custom branch
  <leader>gh - Hunks picker
  <leader>gs - Git status
  <leader>gc - Git commits log

Actions:
  <leader>gC - Commit staged changes
  <leader>gb - Blame current line
  <leader>gB - Blame buffer
  <leader>go - Open in browser
  <leader>gl - LazyGit
  <leader>gL - LazyGit log
  <leader>gf - LazyGit file history

Picker Actions:
  <Enter>   - Open file/jump to hunk
  <Ctrl-s>  - Stage file/hunk
  <Ctrl-u>  - Unstage file/hunk
  <Ctrl-r>  - Reset hunk
  <Ctrl-d>  - Show diff
    ]]
    
    vim.notify(help_text, vim.log.levels.INFO)
  end, { desc = "Git keybindings help" })
end

return M