-- Essential utilities for power users
return {
  -- Which-key - Never forget a keybinding again
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      popup_mappings = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      window = {
        border = "rounded",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 1, 2, 1, 2 },
        winblend = 0,
        zindex = 1000,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
    },
  },

  -- Surround - Master of text objects
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- Comment - Intelligent commenting
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      local comment = require("Comment")
      local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

      comment.setup({
        pre_hook = ts_context_commentstring.create_pre_hook(),
      })
    end,
  },

  -- Auto pairs - Smart bracket completion
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Indent blankline - Beautiful indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },

  -- Todo comments - Never miss a TODO again
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local todo_comments = require("todo-comments")

      local keymap = vim.keymap.set
      keymap("n", "]t", function()
        todo_comments.jump_next()
      end, { desc = "Next todo comment" })

      keymap("n", "[t", function()
        todo_comments.jump_prev()
      end, { desc = "Previous todo comment" })

      todo_comments.setup()
    end,
  },

  -- Trouble - Beautiful diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      focus = true,
    },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open/close trouble list" },
      { "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble workspace diagnostics" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble document diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Open trouble quickfix list" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
      { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
    },
  },

  -- Substitute - Enhanced substitute operations
  {
    "gbprod/substitute.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local substitute = require("substitute")

      substitute.setup()

      local keymap = vim.keymap.set
      keymap("n", "s", substitute.operator, { desc = "Substitute with motion" })
      keymap("n", "ss", substitute.line, { desc = "Substitute line" })
      keymap("n", "S", substitute.eol, { desc = "Substitute to end of line" })
      keymap("x", "s", substitute.visual, { desc = "Substitute in visual mode" })
    end,
  },

  -- Vim-sleuth - Automatic indentation detection
  {
    "tpope/vim-sleuth",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Alpha - Beautiful dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Set header
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ███╗ █████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗ ████║██╔══██╗██╔══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔████╔██║███████║██████╔╝██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╔╝██║██╔══██║██╔══██╗╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚═╝ ██║██║  ██║██║  ██║ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
        "          Minimal Awesome Robust Vim                 ",
      }

      -- Set menu
      dashboard.section.buttons.val = {
        dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
        dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
        dashboard.button("SPC ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
        dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
        dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
      }

      -- Send config to alpha
      alpha.setup(dashboard.opts)

      -- Disable folding on alpha buffer
      vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
  },
} 