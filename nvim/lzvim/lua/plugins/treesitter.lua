return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "cmake",
        "comment",
        "css",
        "devicetree",
        "gitcommit",
        "gitignore",
        "glsl",
        "go",
        "graphql",
        "http",
        "kconfig",
        "meson",
        "ninja",
        "nix",
        "org",
        "php",
        "scss",
        "sql",
        "svelte",
        "vue",
        "wgsl",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["ap"] = "@parameter.outer",
              ["ip"] = "@parameter.inner",
              ["as"] = "@statement.outer",
              ["is"] = "@statement.inner",
              ["aa"] = "@comment.outer",
              ["ia"] = "@comment.inner",
            },
          },
          -- swap = {
          --   enable = true,
          --   swap_next = {
          --     ["<leader>a"] = "@parameter.inner",
          --   },
          --   swap_previous = {
          --     ["<leader>A"] = "@parameter.inner",
          --   },
          -- },
          -- move = {
          --   enable = true,
          --   set_jumps = true,
          --   goto_next_start = {
          --     ["]m"] = "@function.outer",
          --     ["]]"] = "@class.outer",
          --   },
          --   goto_next_end = {
          --     ["]M"] = "@function.outer",
          --     ["]["] = "@class.outer",
          --   },
          --   goto_previous_start = {
          --     ["[m"] = "@function.outer",
          --     ["[["] = "@class.outer",
          --   },
          --   goto_previous_end = {
          --     ["[M"] = "@function.outer",
          --     ["[]"] = "@class.outer",
          --   },
          -- },
        },
      })
    end,
  },
  -- { "IndianBoy42/tree-sitter-just", event = "BufRead justfile", opts = {} },
  -- {
  --   "https://github.com/Samonitari/tree-sitter-caddy",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     opts = function(_, opts)
  --       require("nvim-treesitter.parsers").get_parser_configs().caddy = {
  --         install_info = {
  --           url = "https://github.com/Samonitari/tree-sitter-caddy",
  --           files = { "src/parser.c", "src/scanner.c" },
  --           branch = "master",
  --         },
  --         filetype = "caddy",
  --       }
  --
  --       opts.ensure_installed = opts.ensure_installed or {}
  --       vim.list_extend(opts.ensure_installed, { "caddy" })
  --       vim.filetype.add({
  --         pattern = {
  --           ["Caddyfile"] = "caddy",
  --         },
  --       })
  --     end,
  --   },
  --   event = "BufRead Caddyfile",
  -- },
}
