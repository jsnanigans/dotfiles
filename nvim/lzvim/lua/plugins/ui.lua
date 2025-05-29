return {
    -- {
    --     lazy = false,
    --     "folke/noice.nvim",
    --     opts = function(_, opts)
    --         opts.debug = false
    --         opts.routes = opts.routes or {}
    --         table.insert(opts.routes, {
    --             filter = {
    --                 event = "notify",
    --                 find = "No information available",
    --             },
    --             opts = { skip = true },
    --         })
    --         local focused = true
    --         vim.api.nvim_create_autocmd("FocusGained", {
    --             callback = function()
    --                 focused = true
    --             end,
    --         })
    --         vim.api.nvim_create_autocmd("FocusLost", {
    --             callback = function()
    --                 focused = false
    --             end,
    --         })
    --
    --         table.insert(opts.routes, 1, {
    --             filter = {
    --                 ["not"] = {
    --                     event = "lsp",
    --                     kind = "progress",
    --                 },
    --                 cond = function()
    --                     return not focused
    --                 end,
    --             },
    --             view = "notify_send",
    --             opts = { stop = false },
    --         })
    --
    --         vim.api.nvim_create_autocmd("FileType", {
    --             pattern = "markdown",
    --             callback = function(event)
    --                 vim.schedule(function()
    --                     require("noice.text.markdown").keys(event.buf)
    --                 end)
    --             end,
    --         })
    --         return opts
    --     end,
    -- },

    -- auto-resize windows
    -- {
    --   "anuvyklack/windows.nvim",
    --   enabled = false,
    --   event = "WinNew",
    --   dependencies = {
    --     { "anuvyklack/middleclass" },
    --     { "anuvyklack/animation.nvim", enabled = false },
    --   },
    --   keys = { { "<leader>m", "<cmd>WindowsMaximize<cr>", desc = "Zoom" } },
    --   config = function()
    --     vim.o.winwidth = 5
    --     vim.o.equalalways = false
    --     require("windows").setup({
    --       animation = { enable = false, duration = 150 },
    --     })
    --   end,
    -- },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    },

    -- lualine
    {
        "nvim-lualine/lualine.nvim",
        enabled = true,
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
        opts = function(_, opts)
            local mutagen_state = {}
            local mutagen_jobs = {}

            local function require_plenary_job()
                local Job, _ = pcall(require, "plenary.job")
                if not Job then
                    vim.notify(
                        "plenary.nvim is required for async mutagen status. Please install it.",
                        vim.log.levels.ERROR,
                        { title = "Lualine Mutagen" }
                    )
                    return nil
                end
                return Job
            end

            local function get_mutagen_status()
                local cwd = vim.uv.cwd() or "."
                mutagen_state[cwd] = mutagen_state[cwd] or {
                    updated = 0,
                    total = 0,
                    enabled = vim.fs.find("mutagen.yml", { path = cwd, upward = true })[1] ~= nil,
                    status = {},
                    checking = false,
                }

                local cache = mutagen_state[cwd]
                if not cache.enabled then
                    return cache
                end

                local now = vim.uv.now()
                local refresh_interval = #cache.status > 0 and 5000 or 15000
                local should_refresh = cache.updated + refresh_interval < now

                if mutagen_jobs[cwd] and mutagen_jobs[cwd].job:is_running() then
                    cache.checking = true
                    return cache
                end

                if should_refresh then
                    local Job = require_plenary_job()
                    if not Job then
                        return cache
                    end

                    mutagen_jobs[cwd] = nil
                    cache.checking = true

                    local job = Job:new({
                        command = "mutagen",
                        args = { "project", "list" },
                        cwd = cwd,
                        on_exit = vim.schedule_wrap(function(j, return_val)
                            mutagen_jobs[cwd] = nil
                            mutagen_state[cwd].checking = false

                            if return_val ~= 0 then
                                vim.notify(
                                    "Mutagen command failed (code: " .. return_val .. ")",
                                    vim.log.levels.WARN,
                                    { title = "Mutagen Status" }
                                )
                                return
                            end

                            local sessions = {}
                            local status_details = {}
                            local name = nil
                            for _, line in ipairs(j:result() or {}) do
                                local n = line:match("^Name: (.*)")
                                if n then name = n end
                                local s = line:match("^Status: (.*)")
                                if s then
                                    table.insert(sessions, {
                                        name = name or "unknown",
                                        status = s,
                                        idle = s == "Watching for changes",
                                    })
                                end
                            end

                            for _, session in ipairs(sessions) do
                                if not session.idle then
                                    table.insert(status_details, session.name .. ": " .. session.status)
                                end
                            end

                            mutagen_state[cwd].updated = vim.uv.now()
                            mutagen_state[cwd].total = #sessions
                            mutagen_state[cwd].status = status_details

                            if #sessions == 0 and mutagen_state[cwd].enabled then
                                vim.notify(
                                    "Mutagen running but no active project sessions.",
                                    vim.log.levels.INFO,
                                    { title = "Mutagen Status" }
                                )
                            end
                            require("lualine").refresh({ place = { "lualine_x", "lualine_y", "lualine_z" } })
                        end),
                        on_stderr = vim.schedule_wrap(function(_, data)
                            if data and #data > 0 then
                                vim.notify("Mutagen stderr: " .. data, vim.log.levels.WARN, { title = "Mutagen Status" })
                            end
                            if mutagen_state[cwd] then mutagen_state[cwd].checking = false end
                            if mutagen_jobs[cwd] then mutagen_jobs[cwd] = nil end
                        end),
                    })
                    job:start()
                    mutagen_jobs[cwd] = { job = job, started = vim.uv.now() }
                    return cache
                end

                cache.checking = false
                return cache
            end

            local mutagen_lualine_component = {
                function()
                    local s = get_mutagen_status()
                    if not s or not s.enabled then return "" end

                    local icon = s.checking and "󰔟 "
                        or (#s.status > 0 and "󰨦 "
                            or (s.total > 0 and "󰕣 "
                                or "󰅙 "))

                    local text = tostring(s.total)
                    if #s.status > 0 then
                        text = text .. " (" .. table.concat(s.status, ", ") .. ")"
                    end
                    return icon .. text
                end,
                color = function()
                    local s = mutagen_state[vim.uv.cwd() or "."]
                    if not s or not s.enabled then return nil end
                    if s.checking then return { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("WarningMsg")), "fg#") } end
                    if #s.status > 0 then return { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("ErrorMsg")),
                            "fg#") } end
                    if s.total == 0 then return { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Comment")), "fg#") } end
                    return { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("String")), "fg#") }
                end,
                cond = function()
                    local s = mutagen_state[vim.uv.cwd() or "."]
                    return s and s.enabled
                end,
            }

            opts.options = {
                icons_enabled = true,
                theme = "auto",
                component_separators = '|',
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            }

            opts.sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { { 'filename', path = 1 } },

                lualine_x = { mutagen_lualine_component, 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            }

            opts.inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { 'filename', path = 1 } },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            }

            opts.tabline = {}
            opts.winbar = {}
            opts.inactive_winbar = {}
            opts.extensions = { 'nvim-tree', 'trouble' }

            return opts
        end,
    },
    -- { "folke/which-key.nvim", enabled = true, config = function() end },
    -- { "folke/noice.nvim", enabled = true },

    -- "folke/twilight.nvim",
    -- {
    --     "folke/zen-mode.nvim",
    --     cmd = "ZenMode",
    --     opts = {
    --         window = { backdrop = 0.7 },
    --         plugins = {
    --             gitsigns = true,
    --             tmux = true,
    --             kitty = { enabled = false, font = "+2" },
    --         },
    --     },
    --     keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
    -- },
}
