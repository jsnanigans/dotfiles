local M = {}

-- Workaround for LSP sync issues when formatting
-- This happens when formatters make large changes that confuse the LSP change tracking
function M.safe_format(bufnr, callback)
  bufnr = bufnr or 0
  
  -- Save the current view
  local view = vim.fn.winsaveview()
  
  -- Temporarily disable LSP change tracking
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.server_capabilities.documentFormattingProvider then
      -- Detach temporarily
      vim.lsp.buf_detach_client(bufnr, client.id)
      
      -- Reattach after formatting
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.lsp.buf_attach_client(bufnr, client.id)
        end
      end, 100)
    end
  end
  
  -- Run the format
  if callback then
    callback()
  else
    require("conform").format({
      bufnr = bufnr,
      lsp_fallback = true,
      quiet = true,
    })
  end
  
  -- Restore view
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.fn.winrestview(view)
    end
  end, 50)
end

-- Alternative: Clear undo tree before format (for very large changes)
function M.format_with_clear_undo(bufnr)
  bufnr = bufnr or 0
  local view = vim.fn.winsaveview()
  
  -- Save file first if modified
  if vim.bo[bufnr].modified then
    vim.cmd("write")
  end
  
  -- Format
  require("conform").format({
    bufnr = bufnr,
    lsp_fallback = true,
    quiet = true,
  }, function(err)
    if not err then
      -- Clear undo history after successful format
      vim.cmd("edit!")
      vim.fn.winrestview(view)
    end
  end)
end

return M