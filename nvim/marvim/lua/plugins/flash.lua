-- Flash.nvim - Enhanced navigation with search labels and character motions
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    -- Labels used for jump targets
    labels = "asdfghjklqwertyuiopzxcvbnm",
    
    -- Search configuration
    search = {
      -- Search mode can be "exact", "search", "fuzzy" or a function
      mode = "exact",
      -- Behave like `incsearch`
      incremental = false,
      -- When `true`, flash will be automatically triggered after the
      -- search pattern is entered
      trigger = "",
      -- Maximum number of matches to show
      max_length = false,
      -- Search in all windows
      multi_window = true,
      -- Search forward and backward
      forward = true,
      wrap = true,
      -- search in normal and select mode only
      mode_after = { "n", "t" },
    },
    
    -- Flash jump configuration
    jump = {
      -- save location in the jumplist
      jumplist = true,
      -- jump position
      pos = "start",
      -- add pattern to search history
      history = false,
      -- add pattern to search register
      register = false,
      -- clear highlight after jump
      nohlsearch = false,
      -- automatically jump when there is only one match
      autojump = false,
    },
    
    -- Label configuration
    label = {
      -- allow uppercase labels
      uppercase = true,
      -- add any labels with the correct case here, that you want to exclude
      exclude = "",
      -- add a label for the first match in the current window.
      -- you can always jump to the first match with `<CR>`
      current = true,
      -- show the label after the match
      after = true,
      -- show the label before the match
      before = false,
      -- position of the label extmark
      style = "overlay",
      -- flash tries to re-use labels that were already assigned to a position,
      -- when typing more characters. By default only lower-case labels are re-used.
      reuse = "lowercase",
      -- for the current window, label targets closer to the cursor first
      distance = true,
      -- minimum pattern length to show labels
      min_pattern_length = 0,
      -- Enable this to use rainbow colors to highlight labels
      -- Can be useful for colorblind users
      rainbow = {
        enabled = false,
        -- number between 1 and 9
        shade = 5,
      },
    },
    
    -- Highlight configuration
    highlight = {
      -- show a backdrop with hl-group FlashBackdrop
      backdrop = true,
      -- Highlight the search matches
      matches = true,
      -- extmark priority
      priority = 5000,
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },
    
    -- action to perform when picking a label.
    -- defaults to the jumping logic depending on the mode.
    action = nil,
    
    -- initial pattern to use when opening flash
    pattern = "",
    
    -- When `true`, flash will try to continue the last search
    continue = false,
    
    -- Set config for ftFT motions
    modes = {
      -- Options used when flash is activated through
      -- `f`, `F`, `t`, `T`, `;` and `,` motions
      char = {
        enabled = true,
        -- dynamic configuration for ftFT motions
        config = function(opts)
          -- autohide flash when in operator-pending mode
          opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
          
          -- disable jump labels when not needed
          opts.jump_labels = opts.jump_labels and vim.v.count == 0
          
          -- Show jump labels only when searching for multiple characters
          opts.multi_line = false
        end,
        -- hide after jump when not in operator-pending mode
        autohide = false,
        -- show jump labels
        jump_labels = false,
        -- set to `false` to use the current line only
        multi_line = true,
        -- When using jump labels, don't use these keys
        label = { exclude = "hjkliardc" },
        -- by default all keymaps are enabled, but you can disable some of them,
        -- by removing them from the list.
        keys = { "f", "F", "t", "T", ";", "," },
        char_actions = function(motion)
          return {
            [";"] = "next", -- set to `right` to always go right
            [","] = "prev", -- set to `left` to always go left
            -- clever-f style
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
          }
        end,
        search = { wrap = false },
        highlight = { backdrop = false },
        jump = { register = false },
      },
      -- Options used for treesitter selections
      treesitter = {
        labels = "abcdefghijklmnopqrstuvwxyz",
        jump = { pos = "range" },
        search = { incremental = false },
        label = { before = true, after = true, style = "inline" },
        highlight = {
          backdrop = false,
          matches = false,
        },
      },
      treesitter_search = {
        jump = { pos = "range" },
        search = { multi_window = true, wrap = true, incremental = false },
        remote_op = { restore = true },
        label = { before = true, after = true, style = "inline" },
      },
    },
  },
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
} 