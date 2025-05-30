-- FZF-lua - Fast fuzzy finder alternative to telescope
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>zf", desc = "FZF Files" },
    { "<leader>zr", desc = "FZF Recent files" },
    { "<leader>zb", desc = "FZF Buffers" },
    { "<leader>zg", desc = "FZF Live grep" },
    { "<leader>zh", desc = "FZF Help tags" },
    { "<leader>zc", desc = "FZF Commands" },
    { "<leader>zk", desc = "FZF Keymaps" },
  },
  config = function()
    local fzf = require("fzf-lua")
    
    fzf.setup({
      "telescope", -- Use telescope-like defaults
      
      winopts = {
        height = 0.85,
        width = 0.80,
        row = 0.35,
        col = 0.50,
        border = "rounded",
        fullscreen = false,
        preview = {
          default = "bat",
          border = "border",
          wrap = "nowrap",
          hidden = "nohidden",
          vertical = "down:45%",
          horizontal = "right:60%",
          layout = "flex",
          flip_columns = 120,
          title = true,
          title_pos = "center",
          scrollbar = "float",
          scrolloff = "-2",
          scrollchars = { "█", "" },
          delay = 100,
          winopts = {
            number = true,
            relativenumber = false,
            cursorline = true,
            cursorlineopt = "both",
            cursorcolumn = false,
            signcolumn = "no",
            list = false,
            foldenable = false,
            foldmethod = "manual",
          },
        },
      },
      
      keymap = {
        builtin = {
          ["<F1>"] = "toggle-help",
          ["<F2>"] = "toggle-fullscreen",
          ["<F3>"] = "toggle-preview-wrap",
          ["<F4>"] = "toggle-preview",
          ["<F5>"] = "toggle-preview-ccw",
          ["<F6>"] = "toggle-preview-cw",
          ["<S-down>"] = "preview-page-down",
          ["<S-up>"] = "preview-page-up",
          ["<S-left>"] = "preview-page-reset",
        },
        fzf = {
          ["ctrl-z"] = "abort",
          ["ctrl-u"] = "unix-line-discard",
          ["ctrl-f"] = "half-page-down",
          ["ctrl-b"] = "half-page-up",
          ["ctrl-a"] = "beginning-of-line",
          ["ctrl-e"] = "end-of-line",
          ["alt-a"] = "toggle-all",
          ["f3"] = "toggle-preview-wrap",
          ["f4"] = "toggle-preview",
          ["shift-down"] = "preview-page-down",
          ["shift-up"] = "preview-page-up",
        },
      },
      
      actions = {
        files = {
          ["default"] = fzf.actions.file_edit_or_qf,
          ["ctrl-s"] = fzf.actions.file_split,
          ["ctrl-v"] = fzf.actions.file_vsplit,
          ["ctrl-t"] = fzf.actions.file_tabedit,
          ["alt-q"] = fzf.actions.file_sel_to_qf,
          ["alt-l"] = fzf.actions.file_sel_to_ll,
        },
        buffers = {
          ["default"] = fzf.actions.buf_edit,
          ["ctrl-s"] = fzf.actions.buf_split,
          ["ctrl-v"] = fzf.actions.buf_vsplit,
          ["ctrl-t"] = fzf.actions.buf_tabedit,
        },
      },
      
      fzf_opts = {
        ["--ansi"] = "",
        ["--info"] = "inline",
        ["--height"] = "100%",
        ["--layout"] = "reverse",
        ["--border"] = "none",
      },
      
      previewers = {
        cat = {
          cmd = "cat",
          args = "--number",
        },
        bat = {
          cmd = "bat",
          args = "--style=numbers,changes --color always",
          theme = "Coldark-Dark", -- bat theme, not implemented yet
        },
        head = {
          cmd = "head",
          args = nil,
        },
        git_diff = {
          cmd_deleted = "git show HEAD:{}",
          cmd_modified = "git diff HEAD {}",
          cmd_untracked = "git diff --no-index /dev/null {}",
          pager = "delta --width=$FZF_PREVIEW_COLUMNS",
        },
      },
      
      -- Provider specific configs
      files = {
        prompt = "Files❯ ",
        multiprocess = true,
        git_icons = true,
        file_icons = true,
        color_icons = true,
        find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
        rg_opts = "--color=never --files --hidden --follow -g '!.git'",
        fd_opts = "--color=never --type f --hidden --follow --exclude .git",
      },
      
      git = {
        files = {
          prompt = "GitFiles❯ ",
          cmd = "git ls-files --exclude-standard",
          multiprocess = true,
          git_icons = true,
          file_icons = true,
          color_icons = true,
        },
        status = {
          prompt = "GitStatus❯ ",
          cmd = "git status --short --untracked-files=all",
          multiprocess = true,
          git_icons = true,
          file_icons = true,
          color_icons = true,
        },
        commits = {
          prompt = "Commits❯ ",
          cmd = "git log --color=never --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'",
          multiprocess = true,
        },
        bcommits = {
          prompt = "BCommits❯ ",
          cmd = "git log --color=never --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset' <file>",
          multiprocess = true,
        },
        branches = {
          prompt = "Branches❯ ",
          cmd = "git branch --all --color=never",
          multiprocess = true,
        },
        stash = {
          prompt = "Stash❯ ",
          cmd = "git --no-pager stash list",
          multiprocess = true,
        },
      },
      
      grep = {
        prompt = "Rg❯ ",
        input_prompt = "Grep For❯ ",
        multiprocess = true,
        git_icons = true,
        file_icons = true,
        color_icons = true,
        grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
        rg_glob = true,
        glob_flag = "--iglob",
        glob_separator = "%s%-%-",
      },
      
      args = {
        prompt = "Args❯ ",
        files_only = true,
      },
      
      oldfiles = {
        prompt = "History❯ ",
        cwd_only = false,
        stat_file = true,
        include_current_session = false,
      },
      
      buffers = {
        prompt = "Buffers❯ ",
        file_icons = true,
        color_icons = true,
        sort_lastused = true,
        ignore_current_buffer = false,
        no_term_buffers = true,
        cwd_only = false,
        ls_cmd = "ls -la",
      },
      
      tabs = {
        prompt = "Tabs❯ ",
        tab_title = "Tab",
        tab_marker = "<<",
        file_icons = true,
        color_icons = true,
      },
      
      lines = {
        previewer = "builtin",
        prompt = "Lines❯ ",
        show_unloaded = true,
        show_unlisted = true,
        no_term_buffers = true,
        fzf_opts = {
          ["--delimiter"] = ":",
          ["--nth"] = "2..",
          ["--tiebreak"] = "index",
        },
        actions = {
          ["default"] = fzf.actions.buf_edit_or_qf,
          ["ctrl-s"] = fzf.actions.buf_split,
          ["ctrl-v"] = fzf.actions.buf_vsplit,
          ["ctrl-t"] = fzf.actions.buf_tabedit,
        },
      },
      
      blines = {
        previewer = "builtin",
        prompt = "BLines❯ ",
        show_unloaded = true,
        no_term_buffers = true,
        fzf_opts = {
          ["--delimiter"] = ":",
          ["--with-nth"] = "2..",
          ["--tiebreak"] = "index",
        },
        actions = {
          ["default"] = fzf.actions.buf_edit_or_qf,
          ["ctrl-s"] = fzf.actions.buf_split,
          ["ctrl-v"] = fzf.actions.buf_vsplit,
          ["ctrl-t"] = fzf.actions.buf_tabedit,
        },
      },
    })

    -- Keymaps for FZF-lua (alternative to telescope)
    local keymap = vim.keymap.set
    
    -- File pickers (alternative to telescope)
    keymap("n", "<leader>zf", fzf.files, { desc = "FZF Find files" })
    keymap("n", "<leader>zr", fzf.oldfiles, { desc = "FZF Recent files" })
    keymap("n", "<leader>zb", fzf.buffers, { desc = "FZF Buffers" })
    keymap("n", "<leader>zh", fzf.help_tags, { desc = "FZF Help" })
    keymap("n", "<leader>zk", fzf.keymaps, { desc = "FZF Keymaps" })
    keymap("n", "<leader>zc", fzf.commands, { desc = "FZF Commands" })
    keymap("n", "<leader>z:", fzf.command_history, { desc = "FZF Command history" })
    keymap("n", "<leader>z/", fzf.search_history, { desc = "FZF Search history" })
    
    -- Search pickers
    keymap("n", "<leader>zs", fzf.live_grep, { desc = "FZF Live grep" })
    keymap("n", "<leader>zw", fzf.grep_cword, { desc = "FZF Grep word under cursor" })
    keymap("v", "<leader>zs", fzf.grep_visual, { desc = "FZF Grep selection" })
    keymap("n", "<leader>zl", fzf.lines, { desc = "FZF Lines" })
    keymap("n", "<leader>zL", fzf.blines, { desc = "FZF Buffer lines" })
    
    -- Git pickers
    keymap("n", "<leader>zgf", fzf.git_files, { desc = "FZF Git files" })
    keymap("n", "<leader>zgc", fzf.git_commits, { desc = "FZF Git commits" })
    keymap("n", "<leader>zgb", fzf.git_bcommits, { desc = "FZF Git buffer commits" })
    keymap("n", "<leader>zgB", fzf.git_branches, { desc = "FZF Git branches" })
    keymap("n", "<leader>zgs", fzf.git_status, { desc = "FZF Git status" })
    keymap("n", "<leader>zgt", fzf.git_stash, { desc = "FZF Git stash" })
    
    -- LSP pickers
    keymap("n", "<leader>zlr", fzf.lsp_references, { desc = "FZF LSP references" })
    keymap("n", "<leader>zld", fzf.lsp_definitions, { desc = "FZF LSP definitions" })
    keymap("n", "<leader>zli", fzf.lsp_implementations, { desc = "FZF LSP implementations" })
    keymap("n", "<leader>zlt", fzf.lsp_typedefs, { desc = "FZF LSP type definitions" })
    keymap("n", "<leader>zls", fzf.lsp_document_symbols, { desc = "FZF LSP document symbols" })
    keymap("n", "<leader>zlw", fzf.lsp_workspace_symbols, { desc = "FZF LSP workspace symbols" })
    keymap("n", "<leader>zlD", fzf.lsp_document_diagnostics, { desc = "FZF LSP diagnostics" })
    keymap("n", "<leader>zlW", fzf.lsp_workspace_diagnostics, { desc = "FZF LSP workspace diagnostics" })
    
    -- Other pickers
    keymap("n", "<leader>zq", fzf.quickfix, { desc = "FZF Quickfix" })
    keymap("n", "<leader>zQ", fzf.loclist, { desc = "FZF Location list" })
    keymap("n", "<leader>zt", fzf.tabs, { desc = "FZF Tabs" })
    keymap("n", "<leader>za", fzf.args, { desc = "FZF Args" })
  end,
} 