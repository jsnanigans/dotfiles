M = {}
require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

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
  map("n", "<leader>fa", require('fzf-lua').files, { desc = "Fzf Files" })
  map("n", "<leader>fb", require('fzf-lua').buffers, { desc = "Fzf Buffers" })
  map("n", "<leader>fc", require('fzf-lua').commands, { desc = "Fzf Commands" })
  map("n", "<leader>ff", require('fzf-lua').grep, { desc = "Fzf Grep" })
  map("n", "<leader>fw", require('fzf-lua').live_grep, { desc = "Fzf Live Grep" })
  -- map("n", "<leader>fm", require('fzf-lua').marks, { desc = "Fzf Marks" })
  map("n", "<leader>fp", require('fzf-lua').git_files, { desc = "Fzf Git Files" })
  map("n", "<leader>fr", require('fzf-lua').grep_cword, { desc = "Fzf Grep Word" })
  map("n", "<c-p>", require('fzf-lua').resume, { desc = "Fzf Resume" })
end

return M
