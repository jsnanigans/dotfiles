return {
  {
    "echasnovski/mini.comment",
    version = false,
    event = "VeryLazy",
    opts = {
      options = {
        -- Function to compute commentstring
        custom_commentstring = function()
          -- Try to get treesitter commentstring first
          local ok, ts_cs = pcall(function()
            return require("ts_context_commentstring.internal").calculate_commentstring()
          end)
          if ok and ts_cs then
            return ts_cs
          end
          -- Fallback to buffer's commentstring
          return vim.bo.commentstring
        end,
        -- Whether to ignore blank lines when commenting
        ignore_blank_line = false,
        -- Whether to recognize as comment only lines without indent
        start_of_line = false,
        -- Whether to ensure single space pad for comment markers
        pad_comment_parts = true,
      },
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Toggle comment (like vim-commentary)
        comment = "gc",
        -- Toggle comment on current line
        comment_line = "gcc",
        -- Toggle comment on visual selection
        comment_visual = "gc",
        -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        textobject = "gc",
      },
    },
  },
  {
    "echasnovski/mini.ai",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" },
          e = {
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(),
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
        },
      }
    end,
  },
  {
    "echasnovski/mini.surround",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "echasnovski/mini.bufremove",
    version = false,
    lazy = false,
    config = function()
      require("mini.bufremove").setup()
    end,
  },
  {
    "echasnovski/mini.icons",
    version = false,
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
