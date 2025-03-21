-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.g.vscode then
  -- VSCode Neovim
  require("config.vscode_keymaps")
else
  -- Ordinary Neovim
  require("config.options")
  require("config.lazy")
  require("config.custom")
  require("config.keymaps")
  require("config.autocmds")
end
