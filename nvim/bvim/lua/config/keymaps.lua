M = {}
-- U for "redo"
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true, desc = 'Redo' })

local function map_normal_mode(keys, func, desc)
  -- default values:
  -- noremap: false
  -- silent: false
  vim.keymap.set('n', keys, func, { desc = desc, noremap = false, silent = true })
end

function M.setup_mini_keymaps()
  vim.keymap.set('n', '<C-b>', ':lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', { noremap = true, silent = true, desc = 'Open Files' })
end

function M.setup_hop_keymaps()
  local hop = require 'hop'
  local directions = require('hop.hint').HintDirection
  vim.keymap.set('n', 's', function()
    hop.hint_char1 { direction = directions.AFTER_CURSOR }
  end, { desc = 'Hop Forward', noremap = true, silent = true })
  vim.keymap.set('n', 'S', function()
    hop.hint_char1 { direction = directions.BEFORE_CURSOR }
  end, { desc = 'Hop Back', noremap = true, silent = true })

  vim.keymap.set('n', '<C-f>', ':HopPattern<CR>', { desc = 'Hop Pattern', noremap = true, silent = true })
end

-- file stuff
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true, desc = 'Save' })
vim.keymap.set('n', '<C-o>', ':b#<CR>', { noremap = true, silent = true, desc = 'Go to previous open buffer' })
vim.keymap.set('n', '<leader>qq', ':wqa<CR>', { noremap = true, silent = true, desc = 'Save and quit all' })

function M.setup_whichkey()
  return {
    { '<leader>q', group = 'quick actions' },
    { '<leader>s', group = 'search' },
  }
end

function M.setup_fzf_keymaps()
  -- git

  -- searching
  -- map_normal_mode('<leader><leader>', '<cmd>lua require("fzf-lua").files()<CR>', 'Find Files')
  map_normal_mode('<leader><leader>', function()
    local fzf = require 'fzf-lua'
    fzf.files {
      cmd = 'fd -t f -g | grep -v ".test."',
    }
  end, 'Find Files')
  map_normal_mode('<leader>ft', function()
    local fzf = require 'fzf-lua'
    fzf.files {
      cmd = 'fd -t f -g "*.test.*"',
    }
  end, 'Find test Files')
  map_normal_mode('<leader>fx', function()
    local fzf = require 'fzf-lua'
    fzf.files {
      cmd = 'fd -t f -g "*.[tj]sx"',
    }
  end, 'Find jsx or tsx Files')
  map_normal_mode('<leader>fb', function()
    local fzf = require 'fzf-lua'
    fzf.files {
      cmd = 'fd -t f -g "*[BC][lu][ob][ci][.t]*" | grep -v ".test."',
    }
  end, 'Find bloc or qubit Files')
  map_normal_mode('<leader>b', '<cmd>lua require("fzf-lua").buffers()<CR>', 'Find Files')
  --live grep
  map_normal_mode('<leader>/', '<cmd>lua require("fzf-lua").live_grep()<CR>', 'Find Files')
end

function M.setup_telescope_keymaps()
  -- git
  map_normal_mode('<leader>sc', '<cmd>Telescope git_commits<CR>', '[s]earch git [c]ommits')
  map_normal_mode('<leader>sg', '<cmd>Telescope git_status<CR>', '[s]earch git changes')

  -- searching
  map_normal_mode('<leader>fa', function()
    require('telescope.builtin').find_files {
      find_command = {
        'rg',
        '--hidden',
        '--files',
      },
    }
  end, 'Find Files (All)')

  map_normal_mode('<leader>fb', function()
    require('telescope.builtin').find_files {
      find_command = {
        'rg',
        '--hidden',
        '--files',
        '--type=ts',
        '--type=js',
        '-g=*Cubit.*',
        '-g=*Bloc.*',
        '-g=!*.test.*',
      },
    }
  end, 'Find Files (Test)')
  map_normal_mode('<leader>fib', function()
    require('telescope.builtin').live_grep {
      additional_args = { '--hidden', '--type=ts', '--type=js', '-g=*Cubit.*', '-g=*Bloc.*', '-g=!*.test.*' },
    }
  end, 'Find Files (Test)')

  map_normal_mode('<leader>ft', function()
    require('telescope.builtin').find_files {
      find_command = {
        'rg',
        '--hidden',
        '--files',
        '--type=ts',
        '--type=js',
        '-g=*.test.*',
      },
    }
  end, 'Find Files (Test)')
  map_normal_mode('<leader>fit', function()
    require('telescope.builtin').live_grep {
      additional_args = { '--hidden', '--type=ts', '--type=js', '-g=*.test.*' },
    }
  end, 'Find in Files (Test)')

  map_normal_mode('<leader>fj', function()
    require('telescope.builtin').find_files {
      find_command = {
        'rg',
        '--hidden',
        '--files',
        '--type=ts',
        '--type=js',
        '-g=!*.test.*',
      },
    }
  end, 'Find Files (JS/TS)')
  map_normal_mode('<leader>fij', function()
    require('telescope.builtin').live_grep {
      additional_args = { '--hidden', '--type=ts', '--type=js', '-g=!*.test.*' },
    }
  end, 'Find in Files (JS/TS)')

  map_normal_mode('<leader>fx', function()
    require('telescope.builtin').find_files {
      find_command = {
        'rg',
        '--hidden',
        '--files',
        '--type=ts',
        '--type=js',
        '-g=*.tsx',
        '-g=*.jsx',
        '-g=!*.test.*',
      },
    }
  end, 'Find Files (JSX/TSX)')
  map_normal_mode('<leader>fix', function()
    require('telescope.builtin').live_grep {
      additional_args = { '--hidden', '--type=ts', '--type=js', '-g=*.tsx', '-g=*.jsx', '-g=!*.test.*' },
    }
  end, 'Find in Files (JSX/TSX)')

  map_normal_mode('<leader><leader>', function()
    require('telescope.builtin').buffers { show_all_buffers = true, sort_lastused = true, sort_mru = true, ignore_current_buffer = true }
  end, 'Buffers')
  -- vim.keymap.set('n', '<c-/>', "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
  map_normal_mode('<leader>sb', '<cmd>Telescope buffers<CR>', '[s]earch opened [b]uffers')
  map_normal_mode('<leader>ss', '<cmd>Telescope lsp_workspace_symbols<CR>', 'Symbols')
  map_normal_mode('<leader>ds', '<cmd>Telescope lsp_document_symbols<CR>', 'Symbols')
  map_normal_mode('<leader>sC', '<cmd>Telescope commands<cr>', '[s]earch [C]ommands')
  map_normal_mode('<leader>sp', '<cmd>Telescope spell_suggest<cr>', '[s]earch [C]ommands')
  map_normal_mode('<leader>/', function()
    require('telescope').extensions.live_grep_args.live_grep_args()
  end, '[s]earch [g]rep')
  map_normal_mode('<leader>sf', function()
    local telescope = require 'telescope'

    local function telescope_buffer_dir()
      return vim.fn.expand '%:p:h'
    end

    telescope.extensions.file_browser.file_browser {
      path = '%:p:h',
      cwd = telescope_buffer_dir(),
      respect_gitignore = false,
      hidden = true,
      grouped = true,
      previewer = false,
      initial_mode = 'normal',
      layout_config = { height = 40 },
    }
  end, 'Open File Browser with the path of the current buffer')
end

function M.setup_trouble_keymaps()
  return {
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>cs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>cl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
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

function M.setup_lsp_keymaps(event)
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  -- map('<leader>qf', vim.lsp.diagnostic.set_loclist, 'Quickfix List')
  vim.keymap.set('n', '<leader>oi', '<cmd>OrganizeImports<cr>', {
    desc = 'Organize Imports',
  })

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  -- Find references for the word under your cursor.
  map('gr', ':lua require("telescope.builtin").lsp_references({ show_line = false })<CR>', '[G]oto [R]eferences')

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  map('<leader>cS', require('telescope.builtin').lsp_document_symbols, 'Do[c]ument [S]ymbols (telescope)')

  -- Fuzzy find all the symbols in your current workspace
  --  Similar to document symbols, except searches over your whole project.
  map('<leader>cw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols (telescope)')

  -- Rename the variable under your cursor
  --  Most Language Servers support renaming across files, etc.
  map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  -- Opens a popup that displays documentation about the word under your cursor
  --  See `:help K` for why this keymap
  map('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- lsp rename
  map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
end

function M.setup_spectre_keymaps()
  vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = 'Toggle Spectre',
  })
  vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = 'Search current word',
  })
  vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = 'Search current word',
  })
  vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = 'Search on current file',
  })
end

function M.setup_hlslens_keymaps()
  local kopts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
  vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
  vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
  vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
  vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
  vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

  vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)
end

-- -- yank
-- vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
-- vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
-- vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
-- vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')
--
-- vim.keymap.set('n', '<c-p>', '<Plug>(YankyPreviousEntry)')
-- vim.keymap.set('n', '<c-n>', '<Plug>(YankyNextEntry)')
--
-- local function map_normal_mode(keys, func, desc)
--   -- default values:
--   -- noremap: false
--   -- silent: false
--   vim.keymap.set('n', keys, func, { desc = desc, noremap = false, silent = true })
-- end
--
-- -- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
--
-- -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- -- is not what someone will guess without a bit more experience.
-- --
-- -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- -- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
--
-- -- TIP: Disable arrow keys in normal mode
-- -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
--
-- -- Keybinds to make split navigation easier.
-- --  Use CTRL+<hjkl> to switch between windows
-- --
-- --  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
--
-- function M.setup_spectre_keymaps()
--   map_normal_mode('<leader>spt', ":lua require('spectre').toggle()<CR>", '[s][p]ectre [t]oggle')
--   map_normal_mode('<leader>spw', ":lua require('spectre').open_visual({select_word=true})<CR>", '[s][p]ectre current [w]ord')
--   map_normal_mode('<leader>spf', ':lua require("spectre").open_file_search({select_word=true})<CR>', '[s][p]ectre current [f]ile')
-- end
--
-- function M.setup_ufo_keymaps()
--   map_normal_mode('<C-f>', function()
--     local winid = require('ufo').peekFoldedLinesUnderCursor()
--     if not winid then
--       -- choose one of coc.nvim and nvim lsp
--       vim.fn.CocActionAsync 'definitionHover' -- coc.nvim
--       vim.lsp.buf.hover()
--     end
--   end, 'Peek Folded Lines Under Cursor')
-- end
--
-- function M.setup_gitsigns_keymaps(bufnr)
--   local gs = package.loaded.gitsigns
--
--   vim.keymap.set('n', ']c', function()
--     if vim.wo.diff then
--       return ']c'
--     end
--     vim.schedule(function()
--       gs.next_hunk()
--     end)
--     return '<Ignore>'
--   end, { expr = true })
--
--   vim.keymap.set('n', '[c', function()
--     if vim.wo.diff then
--       return '[c'
--     end
--     vim.schedule(function()
--       gs.prev_hunk()
--     end)
--     return '<Ignore>'
--   end, { expr = true })
--
--   vim.keymap.set({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { buffer = bufnr, silent = true, noremap = true, desc = '[s]tage hunk' })
--   vim.keymap.set({ 'n', 'v' }, '<leader>hS', ':Gitsigns stage_buffer<CR>', { buffer = bufnr, silent = true, noremap = true, desc = '[S]tage buffer' })
--   vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, silent = true, noremap = true, desc = '[u]ndo stage hunk' })
--   vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, silent = true, noremap = true, desc = '[r]eset hunk' })
--   vim.keymap.set('n', '<leader>hR', gs.reset_buffer, { buffer = bufnr, silent = true, noremap = true, desc = '[R]eset buffer' })
--   vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, silent = true, noremap = true, desc = '[p]review hunk' })
--   vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = bufnr, silent = true, noremap = true, desc = '[d]iff this' })
--
--   vim.keymap.set('n', '<leader>hD', function()
--     gs.diffthis '~'
--   end, { buffer = bufnr, silent = true, noremap = true, desc = '[D]iff this ~' })
--
--   vim.keymap.set('n', '<leader>hb', function()
--     gs.blame_line { full = true }
--   end, { buffer = bufnr, silent = true, noremap = true, desc = '[d]iff this' })
--
--   vim.keymap.set('n', '<leader>hB', gs.toggle_current_line_blame, { buffer = bufnr, silent = true, noremap = true, desc = 'Toggle line [B]lame' })
-- end
--
-- function M.setup_whichkey()
--   return {
--     ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
--     ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
--     ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
--     ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
--     ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
--     ['<leader>t'] = { name = '[T]ypeScript', _ = 'which_key_ignore' },
--     ['<leader>n'] = { name = '[N]eoTree', _ = 'which_key_ignore' },
--     ['<leader><tab>'] = {
--       name = '+tab',
--     },
--     -- ["<leader>c"] = {
--     --   name = "+code",
--     -- },
--     -- ["<leader>d"] = {
--     --   name = "+debug",
--     -- },
--     ['<leader>f'] = {
--       name = '+file',
--     },
--     ['<leader>g'] = {
--       name = '+git',
--     },
--     ['<leader>gb'] = {
--       name = '+blame',
--     },
--     ['<leader>gd'] = {
--       name = '+diffview',
--     },
--     ['<leader>h'] = {
--       name = '+hunks',
--     },
--     -- ["<leader>n"] = {
--     --   name = "+notes",
--     -- },
--     -- ["<leader>s"] = {
--     --   name = "+search",
--     -- },
--     ['<leader>sn'] = {
--       name = '+noice',
--     },
--     ['<leader>sp'] = {
--       name = '+spectre',
--     },
--     -- ["<leader>t"] = {
--     --   name = "+test",
--     -- },
--     ['<leader>u'] = {
--       name = '+ui',
--     },
--     -- ["<leader>r"] = {
--     --   name = "+run",
--     -- },
--     ['<leader>x'] = {
--       name = '+diagnostics/quickfix',
--     },
--   }
-- end
--
return M
