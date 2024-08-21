return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.6',
  event = 'VeryLazy',
  dependencies = {
    { 'MunifTanjim/nui.nvim' },
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      enabled = vim.fn.executable 'make' == 1,
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
    {
      'nvim-telescope/telescope-live-grep-args.nvim',
    },
    -- { 'nvim-telescope/telescope-file-browser.nvim' },
    { 'nvim-treesitter/nvim-treesitter' },
    -- { 'nvim-telescope/telescope-frecency.nvim' },
    -- { "smartpde/telescope-recent-files" }
    -- { 'nvim-telescope/telescope-media-files.nvim' },
  },
  config = function()
    local telescope = require 'telescope'
    -- local actions = require 'telescope.actions'
    -- local fb_actions = require('telescope').extensions.file_browser.actions

    local conf = vim.tbl_deep_extend('force', {
      defaults = {
        -- file_ignore_patterns = { '.git/' },
        -- theme = 'dropdown',
        layout_config = {
          -- other layout configuration here
        },
        -- vimgrep_arguments = {
        --   'rg',
        --   '--color=never',
        --   '--no-heading',
        --   '--hidden',
        --   '--with-filename',
        --   '--line-number',
        --   '--column',
        --   '--smart-case',
        --   '--trim',
        -- },
        -- wrap_results = true,
        -- layout_strategy = 'horizontal',
        -- layout_config = { prompt_position = 'top' },
        -- sorting_strategy = 'ascending',
        -- winblend = 0,
      },
      pickers = {
        -- diagnostics = {
        -- theme = 'dropdown',
        --   initial_mode = 'normal',
        --   layout_config = {
        --     preview_cutoff = 9999,
        --   },
        -- },
        -- find_files = {
        --   theme = 'dropdown',
        -- },
        spell_suggest = {
          theme = 'cursor',
        },
      },
      extensions = {
      --   ['ui-select'] = {
      --     require('telescope.themes').get_dropdown {},
      --   },
        -- fzf = {
        --   fuzzy = true, -- false will only do exact matching
        --   override_generic_sorter = true, -- override the generic sorter
        --   override_file_sorter = true, -- override the file sorter
        --   case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        -- },
        -- recent_files = {
        --   -- This extension's options, see below.
        --   only_cwd = true,
        -- },
        -- file_browser = {
        --   theme = 'ivy',
        --   -- disables netrw and use telescope-file-browser in its place
        --   hijack_netrw = true,
        --   mappings = {
        --     -- your custom insert mode mappings
        --     ['n'] = {
        --       -- your custom normal mode mappings
        --       ['a'] = fb_actions.create,
        --       ['r'] = fb_actions.rename,
        --       ['m'] = fb_actions.move,
        --       ['y'] = fb_actions.copy,
        --       ['d'] = fb_actions.remove,
        --       ['h'] = fb_actions.goto_parent_dir,
        --       ['.'] = fb_actions.toggle_hidden,
        --       ['<C-u>'] = function(prompt_bufnr)
        --         for i = 1, 10 do
        --           actions.move_selection_previous(prompt_bufnr)
        --         end
        --       end,
        --       ['<C-d>'] = function(prompt_bufnr)
        --         for i = 1, 10 do
        --           actions.move_selection_next(prompt_bufnr)
        --         end
        --       end,
        --     },
        --   },
        -- },
      },
    }, {})
    telescope.setup(conf)
    telescope.load_extension 'fzf'
    telescope.load_extension 'live_grep_args'
    -- telescope.load_extension("projects")
    telescope.load_extension 'ui-select'
    -- telescope.load_extension 'file_browser'
    -- telescope.load_extension 'media_files'
    -- telescope.load_extension 'frecency'

    -- telescope.load_extension("recent_files")
    -- telescope.load_extension("notify")

    require('config.keymaps').setup_telescope_keymaps()
  end,
}
