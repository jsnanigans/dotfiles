local opts = { noremap = true, silent = true }

-- Prevent x from writing to clipboard
vim.keymap.set("n", "x", '"_x', opts)

-- Center after moving half-page
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Navigate window splits (Note: <C-h/j/k/l> might conflict with smart-splits if enabled)
-- vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
-- vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
-- vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
-- vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Toggle wrap
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", { desc = "Toggle Wrap" })

-- Keep last yanked when pasting in visual mode
vim.keymap.set("v", "p", '"_dP', opts)

-- Previous Buffer
vim.keymap.set("n", "<leader>`", "<cmd>b#<CR>", { desc = "Prev Buffer" })
