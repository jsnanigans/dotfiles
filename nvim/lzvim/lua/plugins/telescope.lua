return {
    {
        "ibhagwan/fzf-lua",
        lazy = false,
        -- optional = true,
        keys = {
            -- {
            --   "<leader>fp",
            --   LazyVim.pick("files", { cwd = require("lazy.core.config").options.root }),
            --   desc = "Find Plugin File",
            -- },
            -- {
            --     "<leader>sp",
            --     function()
            --         local dirs = { "~/dotfiles/nvim/lzvim/lua/plugins" }
            --         require("fzf-lua").live_grep({
            --             filespec = "-- " .. table.concat(vim.tbl_values(dirs), " "),
            --             search = "/",
            --             formatter = "path.filename_first",
            --         })
            --     end,
            --     desc = "Find Lazy Plugin Spec",
            -- },
        },
    },
    {
        "telescope.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        -- optional = true,
        keys = {
            -- lsp
            {
                "gd",
                function()
                    require("telescope.builtin").lsp_definitions()
                end,
                desc = "Goto Definition",
            },
            {
                "gr",
                function()
                    require("telescope.builtin").lsp_references()
                end,
                desc = "Goto References",
            },
            {
              "<leader>co",
              require('util.lsp').action["source.organizeImports"],
              desc = "Organize Imports",
            },
            -- files
            -- {
            --     "<leader>fp",
            --     function()
            --         require("telescope.builtin").find_files({
            --             cwd = require("lazy.core.config").options.root,
            --         })
            --     end,
            --     desc = "Find Plugin File",
            -- },
            {
                "<leader>/",
                function()
                    require("telescope.builtin").live_grep({
                      cwd = vim.g.current_p_root
                    })
                end,
                desc = "Search in files scoped",
            },
            {
                "<leader>f/",
                function()
                    require("telescope.builtin").live_grep()
                end,
                desc = "Search in files scoped",
            },
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files({
                      cwd = vim.g.current_p_root
                    })
                end,
                desc = "Find File in Project Scoped",
            },
            {
                "<leader>fF",
                function()
                    require("telescope.builtin").find_files()
                end,
                desc = "Find File in Project",
            },
            {
                "<leader>fl",
                function()
                    local files = {} ---@type table<string, string>
                    for _, plugin in pairs(require("lazy.core.config").plugins) do
                        repeat
                            if plugin._.module then
                                local info = vim.loader.find(plugin._.module)[1]
                                if info then
                                    files[info.modpath] = info.modpath
                                end
                            end
                            plugin = plugin._.super
                        until not plugin
                    end
                    require("telescope.builtin").live_grep({
                        default_text = "/",
                        search_dirs = vim.tbl_values(files),
                    })
                end,
                desc = "Find Lazy Plugin Spec",
            },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = {
                      width = 0.99,
                      height = 0.99,
                    },
     
                    -- layout_config = {
                    --     horizontal = {
                    --         prompt_position = "top",
                    --         preview_width = 0.5,
                    --     },
                    --     width = 0.8,
                    --     height = 0.8,
                    --     preview_cutoff = 120,
                    -- },
                    -- sorting_strategy = "ascending",
                    -- winblend = 0,
                    path_display = { shorten = 4 },
                },
                          -- defaults={
                          --   layout_strategy = "vertical",
                          --   layout_config = {
                          --     width = 0.99,
                          --     height = 0.95,
                          --   },
                          --   path_display = { shorten = 2 },
                          -- }
                extensions = {
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    }
                },
            })
        end,
    },
}
