-- Session management for project persistence
return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
    options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    pre_save = nil,
    save_empty = false,
  },
  config = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)
    
    -- Create autocmd group for session management
    local session_group = vim.api.nvim_create_augroup("SessionManagement", { clear = true })
    
    -- Auto-save session on exit and periodically
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = session_group,
      callback = function()
        persistence.save()
      end,
      desc = "Save session on exit",
    })
    
    -- Auto-save session every 5 minutes
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = session_group,
      callback = function()
        -- Save session after writing a buffer
        persistence.save()
      end,
      desc = "Save session after buffer write",
    })
    
    -- Auto-load session for the current directory on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      group = session_group,
      nested = true,
      callback = function()
        -- Only auto-load if no files were specified
        if vim.fn.argc() == 0 then
          -- Check if a session exists for the current directory
          local session_file = persistence.current()
          if session_file and vim.fn.filereadable(session_file) == 1 then
            persistence.load()
          end
        end
      end,
      desc = "Auto-load session on startup",
    })
  end,
  keys = {
    {
      "<leader>ps",
      function() require("persistence").load() end,
      desc = "Restore Session for Current Directory",
    },
    {
      "<leader>pl",
      function() require("persistence").load({ last = true }) end,
      desc = "Restore Last Session",
    },
    {
      "<leader>pd",
      function() require("persistence").stop() end,
      desc = "Stop Session Recording",
    },
    {
      "<leader>pS",
      function() require("persistence").save() end,
      desc = "Save Current Session",
    },
    {
      "<leader>pc",
      function() 
        local session_file = require("persistence").current()
        if session_file and vim.fn.filereadable(session_file) == 1 then
          vim.fn.delete(session_file)
          vim.notify("Session deleted for " .. vim.fn.getcwd(), vim.log.levels.INFO)
        else
          vim.notify("No session found for " .. vim.fn.getcwd(), vim.log.levels.WARN)
        end
      end,
      desc = "Clear Session for Current Directory",
    },
  },
}