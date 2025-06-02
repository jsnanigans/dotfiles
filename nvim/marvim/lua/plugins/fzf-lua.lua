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
    
    -- Store the initial workspace root (where nvim was opened)
    local INITIAL_WORKSPACE_ROOT = vim.fn.getcwd()
    
    -- Helper function to find the nearest package.json directory within initial workspace
    local function find_project_root()
      local current_dir = vim.fn.expand('%:p:h')
      local root_patterns = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }
      
      -- Start from current file's directory and go up
      local function find_root(path)
        -- Stop if we've reached the initial workspace root's parent
        local initial_parent = vim.fn.fnamemodify(INITIAL_WORKSPACE_ROOT, ':h')
        if path == initial_parent or vim.fn.fnamemodify(path, ':h') == initial_parent then
          return INITIAL_WORKSPACE_ROOT
        end
        
        for _, pattern in ipairs(root_patterns) do
          if vim.fn.filereadable(path .. '/' .. pattern) == 1 or vim.fn.isdirectory(path .. '/' .. pattern) == 1 then
            return path
          end
        end
        
        local parent = vim.fn.fnamemodify(path, ':h')
        if parent == path then
          return INITIAL_WORKSPACE_ROOT -- Return initial workspace root instead of nil
        end
        
        -- Don't go beyond the initial workspace root
        if vim.fn.stridx(path, INITIAL_WORKSPACE_ROOT) ~= 0 then
          return INITIAL_WORKSPACE_ROOT
        end
        
        return find_root(parent)
      end
      
      -- If current dir is outside initial workspace, use initial workspace
      if vim.fn.stridx(current_dir, INITIAL_WORKSPACE_ROOT) ~= 0 then
        return INITIAL_WORKSPACE_ROOT
      end
      
      return find_root(current_dir)
    end
    
    -- Helper function to get current file's directory
    local function get_current_dir()
      local current_file = vim.fn.expand('%:p')
      if current_file == '' then
        return vim.fn.getcwd()
      end
      return vim.fn.fnamemodify(current_file, ':h')
    end
    
    -- Helper function to find all package.json locations in workspace (for monorepos)
    local function find_monorepo_packages()
      local packages = {}
      
      -- Use find command to locate all package.json files from initial workspace root
      local cmd = "find " .. INITIAL_WORKSPACE_ROOT .. " -name 'package.json' -not -path '*/node_modules/*' 2>/dev/null"
      local handle = io.popen(cmd)
      
      if handle then
        for line in handle:lines() do
          local dir = vim.fn.fnamemodify(line, ':h')
          table.insert(packages, {
            path = dir,
            name = vim.fn.fnamemodify(dir, ':t'),
            relative = vim.fn.fnamemodify(dir, ':~:.'),
          })
        end
        handle:close()
      end
      
      return packages
    end
    
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

    -- Custom fzf functions for different scopes
    local function fzf_current_dir_files()
      local current_dir = get_current_dir()
      fzf.files({
        prompt = "Files in " .. vim.fn.fnamemodify(current_dir, ':t') .. "❯ ",
        cwd = current_dir,
      })
    end
    
    local function fzf_current_dir_grep()
      local current_dir = get_current_dir()
      fzf.live_grep({
        prompt = "Grep in " .. vim.fn.fnamemodify(current_dir, ':t') .. "❯ ",
        cwd = current_dir,
      })
    end
    
    local function fzf_project_files()
      local project_root = find_project_root()
      fzf.files({
        prompt = "Files in " .. vim.fn.fnamemodify(project_root, ':t') .. "❯ ",
        cwd = project_root,
      })
    end
    
    local function fzf_project_grep()
      local project_root = find_project_root()
      fzf.live_grep({
        prompt = "Grep in " .. vim.fn.fnamemodify(project_root, ':t') .. "❯ ",
        cwd = project_root,
      })
    end
    
    local function fzf_workspace_files()
      fzf.files({
        prompt = "Files in " .. vim.fn.fnamemodify(INITIAL_WORKSPACE_ROOT, ':t') .. "❯ ",
        cwd = INITIAL_WORKSPACE_ROOT,
      })
    end
    
    local function fzf_workspace_grep()
      fzf.live_grep({
        prompt = "Grep in " .. vim.fn.fnamemodify(INITIAL_WORKSPACE_ROOT, ':t') .. "❯ ",
        cwd = INITIAL_WORKSPACE_ROOT,
      })
    end
    
    local function fzf_monorepo_picker()
      local packages = find_monorepo_packages()
      
      if #packages == 0 then
        vim.notify("No packages found in monorepo", vim.log.levels.WARN)
        return
      end
      
      -- If only one package, go directly to it
      if #packages == 1 then
        fzf_project_files()
        return
      end
      
      -- Multiple packages - show picker
      local entries = {}
      for _, pkg in ipairs(packages) do
        table.insert(entries, pkg.name .. " (" .. pkg.relative .. ")")
      end
      
      fzf.fzf_exec(entries, {
        prompt = "Select Package❯ ",
        actions = {
          ['default'] = function(selected)
            local idx = 1
            for i, entry in ipairs(entries) do
              if entry == selected[1] then
                idx = i
                break
              end
            end
            fzf.files({
              prompt = "Files in " .. packages[idx].name .. "❯ ",
              cwd = packages[idx].path,
            })
          end,
        }
      })
    end
    
    -- Keymaps - Unified with telescope structure
    local keymap = vim.keymap.set
    
    -- === FILE SEARCH COMMANDS (z prefix for fzf) ===
    -- Project scope (nearest package.json/git root) - most common use case
    keymap("n", "<leader>zf", fzf_project_files, { desc = "FZF files in project" })
    keymap("n", "<leader>zr", fzf.oldfiles, { desc = "FZF recent files" })
    
    -- Current directory scope (where current file is located)
    keymap("n", "<leader>zd", fzf_current_dir_files, { desc = "FZF files in current dir" })
    
    -- Workspace scope (where nvim was opened)
    keymap("n", "<leader>zw", fzf_workspace_files, { desc = "FZF files in workspace root" })
    
    -- Monorepo scope (select package first)
    keymap("n", "<leader>zm", fzf_monorepo_picker, { desc = "FZF files in monorepo package" })
    
    -- === STRING SEARCH COMMANDS ===
    -- Project scope (nearest package.json/git root) - most common use case
    keymap("n", "<leader>zs", fzf_project_grep, { desc = "FZF string in project" })
    keymap("n", "<leader>zc", function()
      local project_root = find_project_root()
      fzf.grep_cword({
        prompt = "Grep word in " .. vim.fn.fnamemodify(project_root, ':t') .. "❯ ",
        cwd = project_root,
      })
    end, { desc = "FZF string under cursor in project" })
    
    -- Current directory scope
    keymap("n", "<leader>zS", fzf_current_dir_grep, { desc = "FZF string in current dir" })
    keymap("n", "<leader>zC", function()
      local current_dir = get_current_dir()
      fzf.grep_cword({
        prompt = "Grep word in " .. vim.fn.fnamemodify(current_dir, ':t') .. "❯ ",
        cwd = current_dir,
      })
    end, { desc = "FZF string under cursor in current dir" })
    
    -- Workspace scope (where nvim was opened)
    keymap("n", "<leader>zW", fzf_workspace_grep, { desc = "FZF string in workspace root" })
    
    -- Monorepo scope (select package first)
    keymap("n", "<leader>zM", function()
      local packages = find_monorepo_packages()
      if #packages == 0 then
        vim.notify("No packages found in monorepo", vim.log.levels.WARN)
        return
      end
      
      local entries = {}
      for _, pkg in ipairs(packages) do
        table.insert(entries, pkg.name .. " (" .. pkg.relative .. ")")
      end
      
      fzf.fzf_exec(entries, {
        prompt = "Select Package for Grep❯ ",
        actions = {
          ['default'] = function(selected)
            local idx = 1
            for i, entry in ipairs(entries) do
              if entry == selected[1] then
                idx = i
                break
              end
            end
            fzf.live_grep({
              prompt = "Grep in " .. packages[idx].name .. "❯ ",
              cwd = packages[idx].path,
            })
          end,
        }
      })
    end, { desc = "FZF string in monorepo package" })
    
    -- === OTHER FIND COMMANDS ===
    keymap("n", "<leader>zt", "<cmd>TodoFzfLua<cr>", { desc = "FZF todos" })
    keymap("n", "<leader>zb", fzf.buffers, { desc = "FZF buffers" })
    keymap("n", "<leader>zh", fzf.help_tags, { desc = "FZF help" })
    keymap("n", "<leader>zk", fzf.keymaps, { desc = "FZF keymaps" })
    keymap("n", "<leader>zq", fzf.commands, { desc = "FZF commands" })
    keymap("n", "<leader>z:", fzf.command_history, { desc = "FZF command history" })
    keymap("n", "<leader>z/", fzf.search_history, { desc = "FZF search history" })
    
    -- Git commands (matching telescope structure)
    keymap("n", "<leader>zgc", fzf.git_commits, { desc = "FZF git commits" })
    keymap("n", "<leader>zgfc", fzf.git_bcommits, { desc = "FZF git commits for current buffer" })
    keymap("n", "<leader>zgb", fzf.git_branches, { desc = "FZF git branches" })
    keymap("n", "<leader>zgst", fzf.git_status, { desc = "FZF git status" })
    
    -- LSP commands (matching telescope structure)
    keymap("n", "<leader>zlds", fzf.lsp_document_symbols, { desc = "FZF document symbols" })
    keymap("n", "<leader>zlws", fzf.lsp_workspace_symbols, { desc = "FZF workspace symbols" })
    keymap("n", "<leader>zlr", fzf.lsp_references, { desc = "FZF references" })
    keymap("n", "<leader>zlfi", fzf.lsp_implementations, { desc = "FZF implementations" })
    keymap("n", "<leader>zlfd", fzf.lsp_definitions, { desc = "FZF definitions" })
    keymap("n", "<leader>zlft", fzf.lsp_typedefs, { desc = "FZF type definitions" })
    
    -- Additional FZF-specific commands
    keymap("n", "<leader>zl", fzf.lines, { desc = "FZF lines in all buffers" })
    keymap("n", "<leader>zL", fzf.blines, { desc = "FZF lines in current buffer" })
    keymap("v", "<leader>zs", fzf.grep_visual, { desc = "FZF grep selection" })
    keymap("n", "<leader>zQ", fzf.quickfix, { desc = "FZF quickfix" })
    keymap("n", "<leader>zZ", fzf.loclist, { desc = "FZF location list" })
    keymap("n", "<leader>zT", fzf.tabs, { desc = "FZF tabs" })
    keymap("n", "<leader>za", fzf.args, { desc = "FZF args" })
  end,
} 