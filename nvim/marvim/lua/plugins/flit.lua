-- Enhanced f/t motions for Leap
return {
  "ggandor/flit.nvim",
  event = "VeryLazy",
  dependencies = {
    "ggandor/leap.nvim",
    "tpope/vim-repeat",
  },
  keys = function()
    ---@type LazyKeys[]
    local ret = {}
    for _, key in ipairs({ "f", "F", "t", "T" }) do
      ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
    end
    return ret
  end,
  opts = {
    keys = { f = 'f', F = 'F', t = 't', T = 'T' },
    -- A string like "nv", "nvo", "o", etc.
    labeled_modes = "v",
    -- Repeat with the trigger key itself.
    clever_repeat = true,
    multiline = true,
    -- Like `leap`s similar argument (call-specific overrides).
    -- E.g.: opts = { equivalence_classes = {} }
    opts = {}
  },
} 