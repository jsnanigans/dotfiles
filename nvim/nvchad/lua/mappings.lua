M = {}
require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local nomap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "<C-o>", ":b#<CR>", { noremap = true, silent = true, desc = "Go to previous open buffer" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

function M.setup_spectre_keymaps()
  map("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
  map(
    "n",
    "<leader>sw",
    '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
    { desc = "Search current word" }
  )
  map(
    "n",
    "<leader>sp",
    '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
    { desc = "Search on current file" }
  )
end

function M.setup_fzflua_keymaps()
  map("n", "<leader>fa", require("fzf-lua").files, { desc = "Fzf Files" })
  map("n", "<leader>fb", require("fzf-lua").buffers, { desc = "Fzf Buffers" })
  -- map("n", "<leader>fc", require('fzf-lua').commands, { desc = "Fzf Commands" })
  -- map("n", "<leader>ff", require('fzf-lua').grep, { desc = "Fzf Grep" })
  map("n", "<leader>fw", require("fzf-lua").live_grep, { desc = "Fzf Live Grep" })
  -- map("n", "<leader>fm", require('fzf-lua').marks, { desc = "Fzf Marks" })
  -- map("n", "<leader>fp", require('fzf-lua').git_files, { desc = "Fzf Git Files" })
  -- map("n", "<leader>fr", require('fzf-lua').grep_cword, { desc = "Fzf Grep Word" })
  map("n", "<c-p>", require("fzf-lua").resume, { desc = "Fzf Resume" })
end

function M.setup_lsp_keymaps(bufnr)
  map("n", "gd", "<cmd>Trouble lsp_definitions<cr>", { buffer = bufnr })

  map("n", "gD", "<cmd>Trouble lsp_declarations<cr>", { buffer = bufnr })

  map("n", "gr", "<cmd>Trouble lsp_references<cr>", { buffer = bufnr })

  map('n', 'qf', '<cmd>Trouble quickfix<cr>', { buffer = bufnr })
end

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

return M
