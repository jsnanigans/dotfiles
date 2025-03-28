return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      local copilot = require("copilot")
      local suggest = require("copilot.suggestion")
      copilot.setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
        },
        filetypes = {
          ["*"] = true,
        },
      })

      -- vim.keymap.set("n", "<C-x>", function()
      --   suggest.toggle_auto_trigger()
      -- end)

      vim.keymap.set("i", "<C-l>", function()
        suggest.accept()
      end)
      -- vim.keymap.set('i', '<C-x>', function()
      --   suggest.prev()
      -- end)
      -- vim.keymap.set('i', '<C-c>', function()
      --   suggest.next()
      -- end)
      vim.keymap.set("i", "<C-z>", function()
        suggest.dismiss()
      end)
      vim.keymap.set("i", "<C-;>", function()
        suggest.accept_word()
      end)
    end,
  },
}
