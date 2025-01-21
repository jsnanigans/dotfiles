-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    callback = function()
        if vim.w.auto_cursorline then
            vim.wo.cursorline = true
            vim.w.auto_cursorline = nil
        end
    end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
    callback = function()
        if vim.wo.cursorline then
            vim.w.auto_cursorline = true
            vim.wo.cursorline = false
        end
    end,
})

vim.g.current_p_root = vim.loop.cwd()

-- backups
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("better_backup", { clear = true }),
    callback = function(event)
        local file = vim.uv.fs_realpath(event.match) or event.match
        local backup = vim.fn.fnamemodify(file, ":p:~:h")
        backup = backup:gsub("[/\\]", "%%")
        vim.go.backupext = backup
    end,
})

vim.filetype.add({
    extension = {
        overlay = "dts",
        keymap = "dts",
    },
})

-- vim.api.nvim_create_autocmd("QuickFixCmdPost", {
--   callback = function()
--     vim.cmd([[Trouble qflist open]])
--   end,
-- })

-- vim.api.nvim_create_autocmd("BufRead", {
--   callback = function(ev)
--     if vim.bo[ev.buf].buftype == "quickfix" then
--       vim.schedule(function()
--         vim.cmd([[cclose]])
--         vim.cmd([[Trouble qflist open]])
--       end)
--     end
--   end,
-- })

-- autocmd BufNewFile,BufRead Fastfile set filetype=ruby
vim.api.nvim_create_autocmd("BufRead", {
    callback = function(ev)
        if vim.fn.expand("%:t") == "Fastfile" then
            vim.bo[ev.buf].filetype = "ruby"
        end


        -- store the current file path in a global variable
        local root_dir = require('lspconfig.util').root_pattern('tsconfig.json', 'package.json', 'jsconfig.json', '.git')(vim.fn.expand('%:p'))
        vim.g.current_p_root = root_dir
    end,
})

-- vim.api.nvim_create_user_command("FormatDisable", function(args)
--   if args.bang then
--     -- FormatDisable! will disable formatting just for this buffer
--     vim.b.disable_autoformat = true
--   else
--     vim.g.disable_autoformat = true
--   end
-- end, {
--   desc = "Disable autoformat-on-save",
--   bang = true,
-- })
-- vim.api.nvim_create_user_command("FormatEnable", function()
--   vim.b.disable_autoformat = false
--   vim.g.disable_autoformat = false
-- end, {
--   desc = "Re-enable autoformat-on-save",
-- })
