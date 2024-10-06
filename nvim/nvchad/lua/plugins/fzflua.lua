return {
  {
    "ibhagwan/fzf-lua",
    lazy = false,
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup {
        winopts = {
          preview = { default = "bat" },
          height = 0.9,
          width = 0.9,
          border = "rounded",
        },
      }
      require("mappings").setup_fzflua_keymaps()
    end,
  },
}
