-- Autocommands for power user workflow
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General settings group
local general = augroup("General", { clear = true })

-- Highlight on yank (with lower timeout for performance)
autocmd("TextYankPost", {
  group = general,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
  desc = "Highlight yanked text",
})

-- Auto format on save for specific filetypes (excluding JS/TS - handled by eslint/prettier)
autocmd("BufWritePre", {
  group = general,
  pattern = { "*.lua", "*.py", "*.json", "*.md" },
  callback = function()
    -- Check if current file is a JS/TS file and skip formatting
    local filetype = vim.bo.filetype
    local js_ts_types = {
      "javascript", "javascriptreact", "typescript", "typescriptreact", "vue"
    }
    
    for _, ft in ipairs(js_ts_types) do
      if filetype == ft then
        return
      end
    end
    
    vim.lsp.buf.format({ async = false })
  end,
  desc = "Auto format on save (excluding JS/TS)",
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  callback = function()
    -- Save cursor position
    local save_cursor = vim.fn.getpos(".")
    -- Remove trailing whitespace
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    -- Restore cursor position
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace",
})

-- Remember last cursor position
autocmd("BufReadPost", {
  group = general,
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") and vim.bo.filetype ~= "commit" then
      vim.cmd('normal! g`"')
    end
  end,
  desc = "Go to last cursor position",
})

-- Auto resize splits when terminal is resized
autocmd("VimResized", {
  group = general,
  pattern = "*",
  command = "tabdo wincmd =",
  desc = "Auto resize splits",
})

-- Close some filetypes with <q>
autocmd("FileType", {
  group = general,
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close with q",
})

-- Performance optimization group
local perf = augroup("Performance", { clear = true })

-- Check for large files and disable heavy features
autocmd({ "BufReadPre", "FileReadPre" }, {
  group = perf,
  callback = function()
    local ok, stats = pcall(vim.loop.fs_stat, vim.fn.expand("<afile>"))
    if ok and stats and stats.size > 1024 * 1024 then -- 1MB
      vim.b.large_file = true
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.winbar = ""
    end
  end,
  desc = "Optimize for large files",
})

-- Terminal settings
local terminal = augroup("Terminal", { clear = true })

autocmd("TermOpen", {
  group = terminal,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.cmd("startinsert")
  end,
  desc = "Terminal settings",
})

-- File type specific settings
local filetypes = augroup("FileTypes", { clear = true })

-- JSON files
autocmd("FileType", {
  group = filetypes,
  pattern = "json",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
  desc = "JSON settings",
})

-- Disable format options for all files to prevent auto-commenting
autocmd("BufEnter", {
  group = filetypes,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable auto-commenting",
})

-- Auto-create directories when saving files
autocmd("BufWritePre", {
  group = general,
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto create dir when saving",
})

-- Disable autocomment on new line
autocmd("BufEnter", {
  group = general,
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
  desc = "Disable autocomment",
})

-- Alpha (dashboard) settings
autocmd("User", {
  group = general,
  pattern = "AlphaReady",
  callback = function()
    vim.cmd([[
      set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
    ]])
  end,
  desc = "Hide tabline in Alpha",
}) 