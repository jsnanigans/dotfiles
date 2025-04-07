-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local util = require("util")
local env = require("util/env")

util.cowboy()
-- util.wezterm()
env.env()

local M = {}

vim.keymap.set("n", "<leader>ae", "<cmd>AerialToggle!<CR>", { desc = "Aerial" })
vim.keymap.set("n", "<leader>`", "<cmd>b#<CR>", { desc = "Prev Buffer" })

local opts = { noremap = true, silent = true }

-- prevent x to write to clipboard
vim.keymap.set("n", "x", '"_x', opts)

-- center after moving
vim.keymap.set("n", "<C-d>", "<D-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<D-u>zz", opts)

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- toggle wrap
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- change word with <c-c>
-- vim.keymap.set({ "n", "x" }, "<C-c>", "<cmd>normal! ciw<cr>a")
vim.keymap.set({ "n", "x" }, "-", "<cmd>Oil<cr>")
-- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- load the session for the current directory
vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end, { desc = "Load session" })
-- select a session to load
vim.keymap.set("n", "<leader>qS", function()
  require("persistence").select()
end, { desc = "Select session" })
-- load the last session
vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end, { desc = "Load last session" })
-- stop Persistence => session won't be saved on exit
vim.keymap.set("n", "<leader>qd", function()
  require("persistence").stop()
end, { desc = "Stop Persistence" })

-- vim.keymap.set("n", "<leader><leader>", "<cmd>lua require('telescope.builtin').buffers()<cr>", { desc = "Find Buffer" })

vim.keymap.set("n", "<leader>cr", ":IncRename ", { desc = "Rename" })
vim.keymap.set("n", "<leader>cR", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Rename current word" })

vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
end, { desc = "Code Format" })

vim.keymap.set("n", "<leader>sp", '<esc><cmd>lua require("spectre").toggle()<CR>', {
  desc = "Toggle Spectre",
})

-- function M.keymaps_copilot()
--     local cp = require("copilot.suggestion")
--     vim.api.set("i", "<C-l>", cp.accept_word())
-- end

function M.setup_spectre_keymaps()
  vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre",
  })
  vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word",
  })
  vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word",
  })
  vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file",
  })
end

function M.setup_vtsls_keymaps()
  -- local vtsls = require("lspconfig").vtsls

  vim.keymap.set("n", "<leader>co", function()
    require("util.lsp").action["source.organizeImports"]()
  end, { desc = "Organize Imports" })

  -- local opts = { noremap = true, silent = true }
  -- vim.keymap.set('n', '<leader>co', vtsls.sortImports, { desc = 'Sort Imports' })
  -- vim.keymap.set("n", "<leader>ca", vtsls.code_action, {
  --   desc = "Code Action",
  -- })
  -- vim.keymap.set("n", "<leader>cr", vtsls.rename, opts)
  -- vim.keymap.set("n", "<leader>cf", vtsls.format, opts)
  -- vim.keymap.set("n", "<leader>cl", vtsls.show_line_diagnostics, opts)
  -- vim.keymap.set("n", "<leader>cq", vtsls.show_diagnostics, opts)
  -- vim.keymap.set("n", "<leader>cs", vtsls.show_symbols, opts)
  -- vim.keymap.set("n", "<leader>cd", vtsls.show_document_diagnostics, opts)
end

vim.keymap.set("n", "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "Code Action" })

vim.keymap.set("n", "<leader>fm", function()
  vim.lsp.buf.execute_command({ command = "typescript.removeUnusedImports", arguments = {} })
  vim.lsp.buf.execute_command({ command = "typescript.sortImports", arguments = {} })
end, { desc = "Remove Unused and Sort Imports" })

function M.setup_trouble_keymaps()
  return {
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
    -- {
    --   'gd',
    --   '<cmd>Trouble lsp_definitions<cr>',
    --   desc = 'Goto Definition (Trouble)',
    -- },
    -- {
    --   'gD',
    --   '<cmd>Trouble lsp_declarations<cr>',
    --   desc = 'Goto Declaration (Trouble)',
    -- },
    -- {
    --   'gr',
    --   '<cmd>TroubleToggle lsp_references<cr>',
    --   desc = 'Goto References (Trouble)',
    -- },
    -- {
    --   'gt',
    --   '<cmd>Trouble lsp_type_definitions<cr>',
    --   desc = 'Goto Type Definition (Trouble)',
    -- },
    -- {
    --   '<leader>qf',
    --   '<cmd>Trouble quickfix<cr>',
    --   desc = 'Quickfix (Trouble)',
    -- },
  }
end

vim.keymap.set("n", "<leader>aat", function()
  require("avante").toggle()
end, { desc = "Avante Toggle" })
vim.keymap.set("n", "<leader>aae", function()
  require("avante").edit()
end, { desc = "Avante Edit" })
vim.keymap.set("n", "<leader>aas", function()
  require("avante").get_suggestions():suggest()
end, { desc = "Avante Suggest" })





-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
-- vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
-- vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
-- vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
-- vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
-- -- moving between splits
-- vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
-- vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
-- vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
-- vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
-- vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
-- -- swapping buffers between windows
-- vim.keymap.set('n', '<leader>wh', require('smart-splits').swap_buf_left)
-- vim.keymap.set('n', '<leader>wj', require('smart-splits').swap_buf_down)
-- vim.keymap.set('n', '<leader>wk', require('smart-splits').swap_buf_up)
-- vim.keymap.set('n', '<leader>wl', require('smart-splits').swap_buf_right)




return M



