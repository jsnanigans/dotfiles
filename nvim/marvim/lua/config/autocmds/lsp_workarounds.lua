-- LSP workarounds for known issues
local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("LspWorkarounds", { clear = true })
  
  -- Workaround for LSP sync errors in Python files
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "python",
    callback = function(ev)
      -- Override format command for this buffer
      vim.api.nvim_buf_create_user_command(ev.buf, "Format", function()
        local ok, workaround = pcall(require, "utils.format_workaround")
        if ok then
          workaround.safe_format(ev.buf)
        else
          -- Fallback to regular format
          require("conform").format({
            bufnr = ev.buf,
            lsp_fallback = true,
            quiet = true,
          })
        end
      end, { desc = "Format Python file with LSP sync workaround" })
    end,
  })
  
  -- Global error handler for LSP sync issues
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "LspError",
    callback = function()
      local error_msg = vim.v.errmsg or ""
      if error_msg:match("attempt to get length of.*prev_line.*nil value") then
        -- Clear the error
        vim.v.errmsg = ""
        -- Notify user with a less intrusive message
        vim.notify("Format completed (LSP sync warning suppressed)", vim.log.levels.INFO)
      end
    end,
  })
end

return M