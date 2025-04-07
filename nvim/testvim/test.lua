local oni = require('nvim-two.suggest')
local two = require('nvim-two.suggest')
local four = require('nvim-two.suggest')
local ui = require('nvim-complete.ui')

local number_to_double = 66
local double = number_to_double + number_to_double

return { {
  dir = "~/Projects/nvim-complete/"},
  {"nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua" },
      })
    end,
  },
}


