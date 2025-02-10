return {
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = "rafamadriz/friendly-snippets",
    lazy = false,

    -- use a release tag to download pre-built binaries
    version = "*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = "default" },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },
  -- {
  --     "hrsh7th/nvim-cmp",
  --     version = false, -- last release is way too old
  --     event = "InsertEnter",
  --     dependencies = {
  --         "hrsh7th/cmp-nvim-lsp",
  --         "hrsh7th/cmp-buffer",
  --         "hrsh7th/cmp-path",
  --     },
  --     -- Not all LSP servers add brackets when completing a function.
  --     -- To better deal with this, LazyVim adds a custom option to cmp,
  --     -- that you can configure. For example:
  --     --
  --     -- ```lua
  --     -- opts = {
  --     --   auto_brackets = { "python" }
  --     -- }
  --     -- ```
  --     opts = function()
  --         -- vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  --         local cmp = require("cmp")
  --         local defaults = require("cmp.config.default")()
  --         local auto_select = true
  --         -- table.insert(opts.sources, {
  --         --   name = "lazydev",
  --         --   group_index = 0, -- set group index to 0 to skip loading LuaLS completions
  --         -- })
  --         return {
  --             auto_brackets = {}, -- configure any filetype to auto add brackets
  --             completion = {
  --                 completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
  --             },
  --             preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
  --             mapping = cmp.mapping.preset.insert({
  --                 ["<C-c>"] = cmp.mapping.abort(),
  --                 ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
  --                 ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  --                 ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  --                 ["<C-f>"] = cmp.mapping.scroll_docs(4),
  --                 ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  --                 ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  --                 ["<C-Space>"] = cmp.mapping.confirm({ select = true }),
  --                 ["<CR>"] = cmp.mapping.confirm({ select = true }),
  --                 ["<C-CR>"] = function(fallback)
  --                     cmp.abort()
  --                     fallback()
  --                 end,
  --             }),
  --             sources = cmp.config.sources({
  --                 { name = "nvim_lsp" },
  --                 { name = "path" },
  --             }, {
  --                 { name = "buffer" },
  --             }),
  --             -- formatting = {
  --             --     format = function(entry, item)
  --             --         local icons = LazyVim.config.icons.kinds
  --             --         if icons[item.kind] then
  --             --             item.kind = icons[item.kind] .. item.kind
  --             --         end
  --
  --             --         local widths = {
  --             --             abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
  --             --             menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
  --             --         }
  --
  --             --         for key, width in pairs(widths) do
  --             --             if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
  --             --                 item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
  --             --             end
  --             --         end
  --
  --             --         return item
  --             --     end,
  --             -- },
  --             experimental = {
  --                 -- ghost_text = {
  --                 --   hl_group = "CmpGhostText",
  --                 -- },
  --             },
  --             sorting = defaults.sorting,
  --         }
  --     end,
  --     -- main = "lazyvim.util.cmp",
  -- },
}
