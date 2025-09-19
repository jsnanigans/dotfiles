-- Keymap configuration using MARVIM framework
local marvim = require("marvim")
local module = marvim.module()
local utils = marvim.utils()
local event = marvim.event()
local toggle = marvim.toggle()

-- Create keymaps module
local M = {}

-- Import modular keymap modules using safe loading
local keymap_utils = module.load("utils.keymaps")
local core = module.load("config.keymaps.core")
local lsp = module.load("config.keymaps.lsp")
local plugins = module.load("config.keymaps.plugins")
local search = module.load("config.keymaps.search")
local root = module.load("config.keymaps.root")

-- Utility functions using framework
local function is_available(mod_name)
  return module.load(mod_name) ~= nil
end

local function plugin_loaded(plugin_name)
  return package.loaded[plugin_name] ~= nil
end

-- ============================================================================
-- PLUGIN KEY TABLES - Re-export from plugins module
-- ============================================================================

-- Re-export all plugin key tables (only if plugins module loaded)
if plugins then
  M.persistence_keys = plugins.persistence_keys
  M.dadbod_keys = plugins.dadbod_keys
  M.copilot_keys = plugins.copilot_keys
  M.opencode_keys = plugins.opencode_keys
  M.undotree_keys = plugins.undotree_keys
  M.dap_keys = plugins.dap_keys
  M.overseer_keys = plugins.overseer_keys
  M.ultest_keys = plugins.ultest_keys
  M.coverage_keys = plugins.coverage_keys
  M.neotest_keys = plugins.neotest_keys
  M.todo_comments_keys = plugins.todo_comments_keys
  M.trouble_keys = plugins.trouble_keys
  M.conform_keys = plugins.conform_keys
  M.luasnip_keys = plugins.luasnip_keys
  M.treesitter_keys = plugins.treesitter_keys
  M.oil_keys = plugins.oil_keys
  M.dropbar_keys = plugins.dropbar_keys
  M.notify_keys = plugins.notify_keys
  M.noice_keys = plugins.noice_keys
  M.smart_splits_keys = plugins.smart_splits_keys
end

-- ============================================================================
-- LSP AND GITSIGNS SETUP FUNCTIONS - Re-export from lsp module
-- ============================================================================

if lsp then
  M.setup_lsp_keybindings = lsp.setup_lsp_keybindings
  M.setup_gitsigns_keybindings = lsp.setup_gitsigns_keybindings -- Kept for compatibility, now uses mini.diff
end

-- ============================================================================
-- PLUGIN KEYMAPS (Non-lazy plugins only)
-- ============================================================================

function M.setup_plugin_keymaps()
  local map = vim.keymap.set

  -- Plugin keymaps are now handled via key tables in plugin configs
  -- Only non-lazy keymaps are set up here

  -- Mason (LSP installer)
  if vim.fn.exists(":Mason") == 2 then
    map("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
  end

  -- LazyGit - MIGRATED TO SNACKS.LAZYGIT
  -- Keymaps now handled in snacks-full.lua config

  -- Git Blame
  if vim.fn.exists(":GitBlameToggle") == 2 then
    map("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Toggle Git Blame" })
  end

  -- Git Conflicts (using mini.git commands)
  map("n", "<leader>gxo", "<cmd>GitConflictChooseOurs<cr>", { desc = "Take Ours" })
  map("n", "<leader>gxt", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Take Theirs" })
  map("n", "<leader>gxb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Take Both" })
  map("n", "<leader>gxn", "<cmd>GitConflictChooseNone<cr>", { desc = "Take None" })
  map("n", "]x", "<cmd>GitConflictNextConflict<cr>", { desc = "Next Conflict" })
  map("n", "[x", "<cmd>GitConflictPrevConflict<cr>", { desc = "Prev Conflict" })

  -- Diffview
  if vim.fn.exists(":DiffviewOpen") == 2 then
    map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
    map("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
    map("n", "<leader>gf", "<cmd>DiffviewFileHistory<cr>", { desc = "File History" })
    map("n", "<leader>gF", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current File History" })
  end

  -- Mini.visits for file navigation (replacing Harpoon)
  local MiniVisits = module.load("mini.visits")
  if MiniVisits then
    -- Add current file to pinned list (like harpoon add)
    map("n", "<leader>H", function()
      MiniVisits.add_label("pinned", vim.fn.expand("%:p"))
      vim.notify("Added to pinned files", vim.log.levels.INFO)
    end, { desc = "Pin File (Mini.visits)" })

    -- Show pinned files menu (like harpoon menu)
    map("n", "<leader>h", function()
      MiniVisits.select_path(nil, { filter = "pinned" })
    end, { desc = "Pinned Files Menu" })

    -- Quick navigation to pinned files (1-5)
    for i = 1, 5 do
      map("n", "<leader>" .. i, function()
        local pinned = MiniVisits.list_paths(nil, { filter = "pinned" })
        if pinned[i] then
          vim.cmd("edit " .. pinned[i])
        else
          vim.notify("No file at position " .. i, vim.log.levels.WARN)
        end
      end, { desc = "Go to Pinned File " .. i })
    end

    -- Additional mini.visits commands
    map("n", "<leader>fv", function()
      MiniVisits.select_path()
    end, { desc = "Recent Files (All)" })
  end

  -- Flash
  local flash = module.load("flash")
  if flash then
    map({ "n", "x", "o" }, "s", function()
      flash.jump()
    end, { desc = "Flash" })
    map({ "n", "x", "o" }, "S", function()
      flash.treesitter()
    end, { desc = "Flash Treesitter" })
    map("o", "r", function()
      flash.remote()
    end, { desc = "Remote Flash" })
    map({ "o", "x" }, "R", function()
      flash.treesitter_search()
    end, { desc = "Treesitter Search" })
    map("c", "<c-s>", function()
      flash.toggle()
    end, { desc = "Toggle Flash Search" })
  end

  -- Mini.surround
  local surround = module.load("mini.surround")
  if surround then
    map({ "n", "v" }, "gsa", function()
      surround.add()
    end, { desc = "Add Surrounding" })
    map("n", "gsd", function()
      surround.delete()
    end, { desc = "Delete Surrounding" })
    map("n", "gsf", function()
      surround.find()
    end, { desc = "Find Right Surrounding" })
    map("n", "gsF", function()
      surround.find_left()
    end, { desc = "Find Left Surrounding" })
    map("n", "gsh", function()
      surround.highlight()
    end, { desc = "Highlight Surrounding" })
    map("n", "gsr", function()
      surround.replace()
    end, { desc = "Replace Surrounding" })
    map("n", "gsn", function()
      surround.update_n_lines()
    end, { desc = "Update `MiniSurround.config.n_lines`" })
  end
end

-- ============================================================================
-- SETUP FUNCTION
-- ============================================================================

-- Add diagnostic command using framework's autocmd
vim.api.nvim_create_user_command("KeymapDiagnostics", function()
  if keymap_utils then
    keymap_utils.print_diagnostics()
  else
    vim.notify("Keymap utils not available", vim.log.levels.ERROR)
  end
end, { desc = "Show keymap diagnostics and conflicts" })

function M.setup()
  -- Emit pre-setup event
  event.emit("KeymapsPreSetup")

  -- Setup core keymaps
  if core then
    core.setup_editor()
    core.setup_windows()
    core.setup_buffers()
    core.setup_tabs()
    core.setup_terminal()
    core.setup_files()
    core.setup_diagnostics()
    core.setup_dev()
  end

  -- Setup root operations
  if root then
    root.setup_root_operations()
  end

  -- Setup plugin keymaps (deferred to avoid conflicts)
  if keymap_utils then
    keymap_utils.setup_deferred(function()
      M.setup_plugin_keymaps()
      -- Setup search keymaps after plugins load
      if search then
        search.setup_search_keymaps()
      end
    end, 100, "plugin_and_search_keymaps")
  else
    -- Fallback: setup immediately if utils not available
    M.setup_plugin_keymaps()
    if search then
      search.setup_search_keymaps()
    end
  end

  -- Emit post-setup event
  event.emit("KeymapsPostSetup")

  -- Listen for toggle events to update feature-dependent keymaps
  event.on("ToggleChanged", function(data)
    local feature = data.feature
    local enabled = data.enabled

    -- Example: Update keymap descriptions based on toggle state
    if feature == "diagnostics" then
      local desc_suffix = enabled and "" or " (disabled)"
      utils.keymap("n", "<leader>cd", function()
        toggle.toggle("diagnostics")
      end, { desc = "Toggle Diagnostics" .. desc_suffix })
    end
  end)
end

-- Initialize
M.setup()

-- Export module
return M