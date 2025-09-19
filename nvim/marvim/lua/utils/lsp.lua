-- LSP Utility Module
-- Migrated to use MARVIM framework for better error handling and consistency
-- This module will be gradually deprecated as functionality moves to the framework

local marvim = require("marvim.plugin_helper")
local M = {}

-- ============================================================================
-- LSP CONFIGURATION
-- ============================================================================

M.config = {
  diagnostics = {
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      },
    },
  },

  inlay_hints = {
    enabled = true,
  },

  codelens = {
    enabled = true,
  },

  document_highlight = {
    enabled = true,
  },

  capabilities = {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  },

  format = {
    formatting_options = nil,
    timeout_ms = nil,
  },
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

function M.get_config(key)
  return M.config[key] or {}
end

-- ============================================================================
-- ON ATTACH CALLBACKS
-- ============================================================================

local on_attach_callbacks = {}

function M.on_attach(callback)
  table.insert(on_attach_callbacks, callback)
end

function M.setup()
  local group = marvim.augroup("LspAttach", { clear = true })
  marvim.autocmd("LspAttach", {
    group = group,
    callback = function(args)
      -- Validate args structure
      if not args or not args.data or not args.data.client_id then
        return
      end

      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.buf

      -- Ensure client and buffer are valid
      if not client or not buffer then
        return
      end

      -- Emit framework event for LSP attachment
      marvim.emit_event("lsp:attach", client, buffer)

      for _, callback in ipairs(on_attach_callbacks) do
        -- Note: pcall for callback safety, not module loading
        pcall(callback, client, buffer)
      end
    end,
  })
end

-- ============================================================================
-- FORMATTING
-- ============================================================================

function M.format(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  
  -- Check if this is a Python file that might trigger the LSP sync bug
  local filetype = vim.bo[buf].filetype
  if filetype == "python" then
    -- Use the safer format workaround for Python files
    local workaround = marvim.safe_require("utils.format_workaround")
    if workaround and workaround.safe_format then
      workaround.safe_format(buf)
      return
    end
  end

  if opts.force_conform then
    local conform = marvim.safe_require("conform")
    if conform and conform.format then
      conform.format(opts)
    end
    return
  end

  local conform = marvim.safe_require("conform")
  if conform and conform.format then
    -- Add quiet flag to suppress LSP sync errors
    conform.format(vim.tbl_extend("force", {
      bufnr = buf,
      lsp_fallback = true,
      timeout_ms = 3000,
      quiet = true,
    }, opts))
  else
    vim.lsp.buf.format(vim.tbl_extend("force", {
      bufnr = buf,
      timeout_ms = 3000,
    }, opts))
  end
end

-- ============================================================================
-- FILE OPERATIONS
-- ============================================================================

function M.rename_file()
  local buf = vim.api.nvim_get_current_buf()
  local old_name = vim.api.nvim_buf_get_name(buf)
  local new_name = vim.fn.input("New name: ", old_name, "file")

  if new_name == "" or new_name == old_name then
    return
  end

  local params = {
    command = "_typescript.applyRenameFile",
    arguments = {
      {
        sourceUri = vim.uri_from_fname(old_name),
        targetUri = vim.uri_from_fname(new_name),
      },
    },
    title = "Rename File",
  }

  local clients = vim.lsp.get_clients({ bufnr = buf })
  for _, client in ipairs(clients) do
    if client.name == "vtsls" then
      -- Check if client supports exec_cmd method
      if client.exec_cmd then
        -- Note: pcall for method safety, not module loading
        pcall(client.exec_cmd, client, params)
      end
      break
    end
  end
end

return M
