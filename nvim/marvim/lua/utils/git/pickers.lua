local M = {}

local function get_git_root()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if not handle then
    return nil
  end
  local result = handle:read("*l")
  handle:close()
  return result
end

local function run_git_command(cmd)
  local handle = io.popen(cmd)
  if not handle then
    return {}
  end
  local result = {}
  for line in handle:lines() do
    table.insert(result, line)
  end
  handle:close()
  return result
end

function M.files_vs_branch(branch)
  local git_root = get_git_root()
  if not git_root then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end

  branch = branch or "release"

  local snacks_available, snacks = pcall(require, "snacks")
  if not snacks_available or not snacks.picker then
    vim.notify("Snacks picker not available", vim.log.levels.ERROR)
    return
  end

  -- Get changed files
  vim.notify("Fetching files changed vs " .. branch .. " branch...", vim.log.levels.INFO)
  
  local cmd = string.format(
    "cd '%s' && { git diff --name-only %s...HEAD 2>/dev/null; git diff --name-only 2>/dev/null; git diff --name-only --cached 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null; } | sort | uniq",
    git_root,
    branch
  )

  local files = run_git_command(cmd)

  if #files == 0 then
    vim.notify(string.format("No changes found compared to %s branch", branch), vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, file in ipairs(files) do
    local full_path = git_root .. "/" .. file
    local status_icon = ""
    local status_text = ""
    
    -- Check file status
    local staged = run_git_command(string.format("cd '%s' && git diff --name-only --cached 2>/dev/null | grep -x '%s' 2>/dev/null", git_root, file))
    local modified = run_git_command(string.format("cd '%s' && git diff --name-only 2>/dev/null | grep -x '%s' 2>/dev/null", git_root, file))
    local untracked = run_git_command(string.format("cd '%s' && git ls-files --others --exclude-standard 2>/dev/null | grep -x '%s' 2>/dev/null", git_root, file))
    
    if #staged > 0 then
      status_icon = "✓"
      status_text = "Staged"
    elseif #modified > 0 then
      status_icon = "●"
      status_text = "Modified"
    elseif #untracked > 0 then
      status_icon = "?"
      status_text = "Untracked"
    else
      status_icon = "○"
      status_text = "Branch"
    end

    table.insert(items, {
      display = string.format("%-2s %-10s %s", status_icon, status_text, file),
      file = full_path,
      filename = file,
      status = status_text,
    })
  end

  -- Use picker.select for custom items
  local selected_items = {}
  
  snacks.picker.select(items, {
    title = string.format("Git Files (vs %s)", branch),
    format_item = function(item)
      return item.display
    end,
    on_change = function(item)
      -- Preview file on change
      if item and item.file then
        vim.cmd("pedit " .. vim.fn.fnameescape(item.file))
      end
    end,
  }, function(item)
    if item and item.file then
      vim.cmd("edit " .. vim.fn.fnameescape(item.file))
    end
  end)
end

function M.hunks_picker()
  local git_root = get_git_root()
  if not git_root then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end

  local snacks_available, snacks = pcall(require, "snacks")
  if not snacks_available or not snacks.picker then
    vim.notify("Snacks picker not available", vim.log.levels.ERROR)
    return
  end

  vim.notify("Fetching git hunks...", vim.log.levels.INFO)

  local cmd = string.format(
    "cd '%s' && { git diff --unified=0 --no-prefix 2>/dev/null; echo '===STAGED==='; git diff --cached --unified=0 --no-prefix 2>/dev/null; }",
    git_root
  )

  local output = run_git_command(cmd)
  local hunks = {}
  local current_file = nil
  local current_hunk = nil
  local is_staged = false

  for _, line in ipairs(output) do
    if line == "===STAGED===" then
      is_staged = true
    elseif line:match("^%+%+%+ ") then
      current_file = line:match("^%+%+%+ (.+)$")
    elseif line:match("^@@ ") then
      if current_file then
        local old_start, old_count, new_start, new_count = line:match("^@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@")
        local context = line:match("@@ .+ @@ (.*)$") or ""
        
        current_hunk = {
          file = current_file,
          old_start = tonumber(old_start) or 1,
          old_count = tonumber(old_count) or 1,
          new_start = tonumber(new_start) or 1,
          new_count = tonumber(new_count) or 1,
          context = context:sub(1, 50),
          changes = {},
          staged = is_staged,
        }
        table.insert(hunks, current_hunk)
      end
    elseif current_hunk and (line:match("^[%+%-]") or line:match("^\\")) then
      table.insert(current_hunk.changes, line)
    end
  end

  if #hunks == 0 then
    vim.notify("No hunks found", vim.log.levels.INFO)
    return
  end

  local items = {}
  for i, hunk in ipairs(hunks) do
    local status_icon = hunk.staged and "✓" or "●"
    local status_text = hunk.staged and "Staged" or "Modified"
    local added = 0
    local removed = 0
    
    for _, change in ipairs(hunk.changes) do
      if change:match("^%+") then
        added = added + 1
      elseif change:match("^%-") then
        removed = removed + 1
      end
    end

    local display_file = hunk.file
    if #display_file > 30 then
      display_file = "..." .. display_file:sub(-27)
    end

    table.insert(items, {
      display = string.format("%s %-8s %-30s L%-5d (+%d/-%d)",
        status_icon,
        status_text,
        display_file,
        hunk.new_start,
        added,
        removed
      ),
      hunk = hunk,
      file_path = git_root .. "/" .. hunk.file,
    })
  end

  snacks.picker.select(items, {
    title = "Git Hunks",
    format_item = function(item)
      return item.display
    end,
    on_change = function(item)
      -- Preview hunk location
      if item and item.file_path then
        vim.cmd("pedit +" .. item.hunk.new_start .. " " .. vim.fn.fnameescape(item.file_path))
      end
    end,
  }, function(item)
    if item and item.file_path then
      vim.cmd("edit " .. vim.fn.fnameescape(item.file_path))
      vim.api.nvim_win_set_cursor(0, {item.hunk.new_start, 0})
      vim.cmd("normal! zz")
    end
  end)
end

function M.commit()
  local git_root = get_git_root()
  if not git_root then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end

  local staged = run_git_command("git diff --name-only --cached")
  if #staged == 0 then
    vim.notify("No files staged for commit", vim.log.levels.WARN)
    return
  end

  -- Show staged files
  local staged_list = "Staged files:\n"
  for _, file in ipairs(staged) do
    staged_list = staged_list .. "  ✓ " .. file .. "\n"
  end
  vim.notify(staged_list, vim.log.levels.INFO)

  vim.ui.input({
    prompt = "Commit message: ",
    default = "",
  }, function(message)
    if not message or message == "" then
      vim.notify("Commit cancelled", vim.log.levels.INFO)
      return
    end

    local cmd = string.format("cd '%s' && git commit -m %s", git_root, vim.fn.shellescape(message))
    local output = vim.fn.system(cmd)
    
    if vim.v.shell_error == 0 then
      vim.notify("Commit successful!\n" .. output, vim.log.levels.INFO)
    else
      vim.notify("Commit failed:\n" .. output, vim.log.levels.ERROR)
    end
  end)
end

function M.stage_all()
  local git_root = get_git_root()
  if not git_root then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end

  local cmd = string.format("cd '%s' && git add -A", git_root)
  vim.fn.system(cmd)
  
  -- Show what was staged
  local staged = run_git_command("git diff --name-only --cached")
  if #staged > 0 then
    local msg = "Staged " .. #staged .. " file(s):\n"
    for i, file in ipairs(staged) do
      if i <= 10 then
        msg = msg .. "  ✓ " .. file .. "\n"
      elseif i == 11 then
        msg = msg .. "  ... and " .. (#staged - 10) .. " more\n"
        break
      end
    end
    vim.notify(msg, vim.log.levels.INFO)
  else
    vim.notify("No changes to stage", vim.log.levels.INFO)
  end
end

function M.unstage_all()
  local git_root = get_git_root()
  if not git_root then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end

  local staged = run_git_command("git diff --name-only --cached")
  if #staged == 0 then
    vim.notify("No staged files to unstage", vim.log.levels.INFO)
    return
  end

  local cmd = string.format("cd '%s' && git reset HEAD", git_root)
  vim.fn.system(cmd)
  
  local msg = "Unstaged " .. #staged .. " file(s):\n"
  for i, file in ipairs(staged) do
    if i <= 10 then
      msg = msg .. "  ● " .. file .. "\n"
    elseif i == 11 then
      msg = msg .. "  ... and " .. (#staged - 10) .. " more\n"
      break
    end
  end
  vim.notify(msg, vim.log.levels.INFO)
end

-- Interactive staging with mini.diff hunks
function M.stage_hunk_interactive()
  local snacks = require("snacks")
  
  -- Get current buffer hunks from mini.diff
  local buf = vim.api.nvim_get_current_buf()
  local ok, diff_data = pcall(function() return require("mini.diff").get_buf_data(buf) end)
  
  if not ok or not diff_data or not diff_data.hunks or #diff_data.hunks == 0 then
    vim.notify("No hunks in current buffer", vim.log.levels.INFO)
    return
  end

  local filename = vim.api.nvim_buf_get_name(buf)
  local items = {}
  
  for i, hunk in ipairs(diff_data.hunks) do
    local added = 0
    local removed = 0
    
    -- Count changes in hunk
    for line_num = hunk.buf_start, hunk.buf_start + hunk.buf_count - 1 do
      local line = vim.api.nvim_buf_get_lines(buf, line_num - 1, line_num, false)[1] or ""
      -- Simple heuristic for changes (could be improved)
      if #line > 0 then
        added = added + 1
      end
    end
    
    table.insert(items, {
      display = string.format("Hunk %d: Lines %d-%d (+%d/-%d)",
        i,
        hunk.buf_start,
        hunk.buf_start + hunk.buf_count - 1,
        added,
        hunk.ref_count - hunk.buf_count
      ),
      hunk = hunk,
      index = i,
    })
  end

  snacks.picker.select(items, {
    title = "Select hunks to stage",
    format_item = function(item)
      return item.display
    end,
    multi_select = true,
  }, function(selected)
    if not selected or #selected == 0 then
      vim.notify("No hunks selected", vim.log.levels.INFO)
      return
    end
    
    -- Stage selected hunks (simplified - would need proper git apply logic)
    for _, item in ipairs(selected) do
      vim.notify("Would stage hunk " .. item.index .. " (not fully implemented)", vim.log.levels.WARN)
    end
  end)
end

function M.setup()
  -- User commands
  vim.api.nvim_create_user_command("GitFilesVsBranch", function(opts)
    M.files_vs_branch(opts.args ~= "" and opts.args or nil)
  end, {
    nargs = "?",
    desc = "Show files changed compared to a branch (default: release)",
  })

  vim.api.nvim_create_user_command("GitHunks", function()
    M.hunks_picker()
  end, {
    desc = "Show git hunks picker",
  })

  vim.api.nvim_create_user_command("GitCommit", function()
    M.commit()
  end, {
    desc = "Commit staged changes",
  })

  vim.api.nvim_create_user_command("GitStageAll", function()
    M.stage_all()
  end, {
    desc = "Stage all changes",
  })

  vim.api.nvim_create_user_command("GitUnstageAll", function()
    M.unstage_all()
  end, {
    desc = "Unstage all changes",
  })

  vim.api.nvim_create_user_command("GitStageHunkInteractive", function()
    M.stage_hunk_interactive()
  end, {
    desc = "Interactive hunk staging for current buffer",
  })
end

return M