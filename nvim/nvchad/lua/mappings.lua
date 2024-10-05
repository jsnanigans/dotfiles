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

return M
