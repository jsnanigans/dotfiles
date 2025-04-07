return {
  {
    "stevearc/conform.nvim",
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "prettierd", "prettier" },
        ["javascriptreact"] = { "prettierd", "prettier" },
        ["typescript"] = { "prettierd", "prettier" },
        ["typescriptreact"] = { "prettierd", "prettier" },
        ["lua"] = { "stylua" },
      },
      -- formatters_by_ft = {
      --   ["javascript"] = { "dprint", { "prettierd", "prettier" } },
      --   ["javascriptreact"] = { "dprint" },
      --   ["typescript"] = { "dprint", { "prettierd", "prettier" } },
      --   ["typescriptreact"] = { "dprint" },
      -- },
      -- formatters = {
      --   dprint = {
      --     condition = function(_, ctx)
      --       return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
      --     end,
      --   },
      -- },
    },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
        end,
        desc = "Format Code",
      },
    },
  },
}