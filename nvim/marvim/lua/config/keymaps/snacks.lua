local M = {}

-- Helper function
local function is_available(plugin)
  local ok = pcall(require, plugin)
  return ok
end

-- Session management (replaces persistence)
M.session_keys = {
  {
    "<leader>qs",
    function()
      require("snacks").session.load()
    end,
    desc = "Load Session",
  },
  {
    "<leader>ql",
    function()
      require("snacks").session.load({ last = true })
    end,
    desc = "Load Last Session",
  },
  {
    "<leader>qd",
    function()
      require("snacks").session.stop()
    end,
    desc = "Stop Session",
  },
  {
    "<leader>qS",
    function()
      require("snacks").session.save()
    end,
    desc = "Save Session",
  },
  {
    "<leader>qr",
    function()
      require("snacks").session.restore()
    end,
    desc = "Restore Session",
  },
}

-- Notifications (replaces noice)
M.notifier_keys = {
  {
    "<leader>sn",
    function()
      require("snacks").notifier.show()
    end,
    desc = "Show Notifications",
  },
  {
    "<leader>snh",
    function()
      require("snacks").notifier.history()
    end,
    desc = "Notification History",
  },
  {
    "<leader>snc",
    function()
      require("snacks").notifier.clear()
    end,
    desc = "Clear Notifications",
  },
  {
    "<leader>snd",
    function()
      require("snacks").notifier.dismiss()
    end,
    desc = "Dismiss Notification",
  },
}

-- Git UI (replaces lazygit)
M.lazygit_keys = {
  {
    "<leader>gg",
    function()
      require("snacks").lazygit.open()
    end,
    desc = "LazyGit",
  },
  {
    "<leader>gf",
    function()
      require("snacks").lazygit.file()
    end,
    desc = "LazyGit File History",
  },
  {
    "<leader>gl",
    function()
      require("snacks").lazygit.log()
    end,
    desc = "LazyGit Log",
  },
  {
    "<leader>gc",
    function()
      require("snacks").lazygit.log({ cwd = vim.fn.expand("%:p:h") })
    end,
    desc = "LazyGit Current File Dir",
  },
}

-- Navigation (replaces flash)
M.jump_keys = {
  {
    "s",
    mode = { "n", "x", "o" },
    function()
      require("snacks").jump.jump()
    end,
    desc = "Jump",
  },
  {
    "S",
    mode = { "n", "x", "o" },
    function()
      require("snacks").jump.jump({ treesitter = true })
    end,
    desc = "Jump Treesitter",
  },
  -- Enhanced jump with word mode
  {
    "gs",
    mode = { "n", "x", "o" },
    function()
      require("snacks").jump.jump({ mode = "word" })
    end,
    desc = "Jump Word",
  },
  -- Jump to line
  {
    "gl",
    mode = { "n", "x", "o" },
    function()
      require("snacks").jump.jump({ mode = "line" })
    end,
    desc = "Jump Line",
  },
}

-- TODO Comments (using picker patterns)
M.todo_keys = {
  {
    "<leader>st",
    function()
      require("snacks").picker.grep({
        pattern = "TODO|HACK|PERF|NOTE|FIX|FIXME|WARNING",
        flags = "--case-sensitive",
      })
    end,
    desc = "Search TODOs",
  },
  {
    "<leader>sT",
    function()
      require("snacks").picker.grep({
        pattern = "TODO|FIX|FIXME",
        flags = "--case-sensitive",
      })
    end,
    desc = "Search FIXMEs Only",
  },
  {
    "]t",
    function()
      -- Navigate to next TODO using vim search
      vim.fn.search("\\(TODO\\|HACK\\|PERF\\|NOTE\\|FIX\\|FIXME\\|WARNING\\):", "")
    end,
    desc = "Next TODO",
  },
  {
    "[t",
    function()
      -- Navigate to previous TODO using vim search
      vim.fn.search("\\(TODO\\|HACK\\|PERF\\|NOTE\\|FIX\\|FIXME\\|WARNING\\):", "b")
    end,
    desc = "Previous TODO",
  },
}

-- Toggle utilities (partial which-key replacement for toggles)
M.toggle_keys = {
  {
    "<leader>ud",
    function()
      require("snacks").toggle.diagnostics()
    end,
    desc = "Toggle Diagnostics",
  },
  {
    "<leader>uw",
    function()
      require("snacks").toggle.wrap()
    end,
    desc = "Toggle Wrap",
  },
  {
    "<leader>us",
    function()
      require("snacks").toggle.spell()
    end,
    desc = "Toggle Spell",
  },
  {
    "<leader>un",
    function()
      require("snacks").toggle.number()
    end,
    desc = "Toggle Line Numbers",
  },
  {
    "<leader>ur",
    function()
      require("snacks").toggle.relativenumber()
    end,
    desc = "Toggle Relative Numbers",
  },
  {
    "<leader>uc",
    function()
      require("snacks").toggle.conceallevel()
    end,
    desc = "Toggle Conceal Level",
  },
  {
    "<leader>ui",
    function()
      require("snacks").toggle.indent()
    end,
    desc = "Toggle Indent Guides",
  },
  {
    "<leader>ub",
    function()
      require("snacks").toggle.background()
    end,
    desc = "Toggle Background",
  },
}

-- Utility functions
M.util_keys = {
  -- Rename file
  {
    "<leader>fn",
    function()
      require("snacks").rename.rename()
    end,
    desc = "Rename File",
  },
  -- Delete file
  {
    "<leader>fd",
    function()
      require("snacks").bufdelete.delete()
    end,
    desc = "Delete File",
  },
  -- Close other buffers
  {
    "<leader>bo",
    function()
      require("snacks").bufdelete.other()
    end,
    desc = "Delete Other Buffers",
  },
}

-- Combine all keys
M.setup = function()
  local keys = {}

  -- Merge all key tables
  for _, key_table in pairs({
    M.session_keys,
    M.notifier_keys,
    M.lazygit_keys,
    M.jump_keys,
    M.todo_keys,
    M.toggle_keys,
    M.util_keys,
  }) do
    for _, key in ipairs(key_table) do
      table.insert(keys, key)
    end
  end

  return keys
end

return M
