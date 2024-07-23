-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath 'data' .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd 'echo "Installing `mini.nvim`" | redraw'
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd 'packadd mini.nvim | helptags ALL'
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup { path = { package = path_package } }

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- mini.files : https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-files.md
-- now(function()
--   require('mini.files').setup {
--     windows = {
--       preview = true,
--     },
--   }
-- end)

now(function()
  require('mini.ai').setup()
end)
-- now(function() require('mini.bufremove').setup() end)
-- now(function()
--   require('mini.comment').setup()
-- end)
-- now(function() require('mini.cursorword').setup() end)
-- now(function() require('mini.indentscope').setup() end)
-- now(function() require('mini.jump2d').setup() end)
-- now(function()
--   require('mini.pairs').setup()
-- end)
-- now(function()
--   require('mini.sessions').setup({
--   })
-- end)
-- now(function() require('mini.starter').setup() end)
-- now(function()
--   require('mini.statusline').setup()
-- end)
-- now(function()
--   require('mini.surround').setup()
-- end)
-- now(function() require('mini.bracketed').setup() end)

-- now(function() require('mini.tabline').setup() end)
-- now(function() require('mini.statusline').setup() end)

-- Safely execute later
-- later(function() require('mini.ai').setup() end)
-- later(function() require('mini.comment').setup() end)
-- later(function() require('mini.pick').setup() end)
-- later(function() require('mini.surround').setup() end)

-- Use external plugins with `add()`
now(function()
  -- Add to current session (install if absent)
  add 'echasnovski/mini.icons'
  require('mini.icons').setup()
end)
now(function()
  -- Add to current session (install if absent)
  add 'nvim-tree/nvim-web-devicons'
  require('nvim-web-devicons').setup()
end)

-- now(function()
-- Supply dependencies near target plugin
-- add({ source = 'neovim/nvim-lspconfig', depends = { 'williamboman/mason.nvim' } })
-- end)

-- later(function()
--     add({
--         source = 'nvim-treesitter/nvim-treesitter',
--         -- Use 'master' while monitoring updates in 'main'
--         checkout = 'master',
--         monitor = 'main',
--         -- Perform action after every checkout
--         hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
--     })
--     require('nvim-treesitter.configs').setup({
--         ensure_installed = { 'lua', 'vimdoc' },
--         highlight = { enable = true },
--     })
-- end)

require('config.keymaps').setup_mini_keymaps()
