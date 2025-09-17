local M = {}
local keymap_utils = require("utils.keymaps")
local constants = require("config.keymap_constants")

-- These functions are now available in constants module
-- Keeping local aliases for backward compatibility
local build_file_args = constants.build_file_args
local build_grep_args = constants.build_grep_args

-- ============================================================================
-- SEARCH AND PICKER KEYMAPS
-- ============================================================================

function M.setup_search_keymaps()
  -- Validate dependencies
  local deps_ok, missing = keymap_utils.validate_dependencies(constants.PLUGIN_DEPS.SEARCH, "search_keymaps")
  if not deps_ok then
    return false
  end

  local available, snacks = keymap_utils.is_available("snacks")
  if not available or not snacks.picker then
    vim.notify("Snacks picker not available for search keymaps", vim.log.levels.WARN)
    return false
  end

  local map = keymap_utils.create_safe_mapper("search")

  -- File finding and search - excludes test files by default
  local standard_file_args = build_file_args(constants.COMMON_EXCLUDES, constants.TEST_PATTERNS)

  -- Predefined segment styles for common monorepo packages
  local predefined_segments = {
    -- Apps
    ["pmp"] = {  hl = "DiagnosticError" },
    ["user-app"] = {  hl = "DiagnosticInfo" },
    ["e2e"] = {  hl = "Todo" },

    -- Packages
    ["blac-next"] = {  hl = "@function" },
    ["blac-react"] = {  hl = "@keyword" },
    ["cap-healthkit"] = {  hl = "DiagnosticOk" },
    ["cap-healthkit-healthconnect"] = {  hl = "DiagnosticOk" },
    ["health-report-generator"] = {  hl = "DiagnosticInfo" },
    ["openapi"] = {  hl = "@string" },
    ["prettier-config"] = {  hl = "Special" },
    ["shared"] = {  hl = "@type" },
    ["wcl"] = {  hl = "DiagnosticWarn" },
  }

  -- Cache for dynamic segment styles
  local segment_styles = {}
  local segment_counter = 0

  -- Fallback colors
  local fallback_colors = {
    "DiagnosticError",
    "DiagnosticWarn",
    "DiagnosticInfo",
    "DiagnosticOk",
    "@function",
    "@string",
    "@keyword",
    "@type",
    "Special",
    "Todo",
  }

  -- Custom formatter for monorepo with predefined/dynamic colors
  local function monorepo_format(item, picker)
    local ret = {}

    -- Extract monorepo segment
    if item.file then
      local segment
      local patterns = { "apps/([^/]+)", "packages/([^/]+)" }

      for _, pattern in ipairs(patterns) do
        segment = item.file:match(pattern)
        if segment then
          break
        end
      end

      if segment then
        -- Get style from predefined or create dynamic style
        local style = predefined_segments[segment]

        if not style then
          -- Check cache for previously assigned dynamic style
          style = segment_styles[segment]

          if not style then
            -- Create new dynamic style for unknown segment
            segment_counter = segment_counter + 1
            local color_idx = ((segment_counter - 1) % #fallback_colors) + 1

            style = {
              hl = fallback_colors[color_idx],
            }
            segment_styles[segment] = style
          end
        end

        -- Add formatted segment
        -- limit segment length to max 5 chars
        local segment_short_name = segment
        if #segment > 5 then
          segment_short_name = segment:sub(1, 12) .. "…"
        end
        ret[#ret + 1] = { "", style.hl, virtual = true }
        ret[#ret + 1] = { "[" .. segment_short_name .. "] ", style.hl, virtual = true }
      end
    end

    -- Add standard file formatting
    vim.list_extend(ret, require("snacks.picker.format").file(item, picker))

    return ret
  end

  -- Simple option: Use built-in path_segment in file formatter (single color)
  local simple_monorepo_opts = {
    args = standard_file_args,
    formatters = {
      file = {
        path_segment = {
          enabled = true,
          patterns = { "apps/([^/]+)", "packages/([^/]+)" },
          format = "[%s] ",
          hl = "Special",
        },
      },
    },
  }

  -- Complex option: Custom formatter with hash-based colors
  local monorepo_opts = {
    args = standard_file_args,
    format = monorepo_format,
  }

  map("n", "<leader><leader>", function()
    snacks.picker.files(monorepo_opts)
  end, { desc = "Find Files" })

  map("n", "<leader>ff", function()
    snacks.picker.files(monorepo_opts)
  end, { desc = "Find Files" })

  -- Recent files and buffers
  map("n", "<leader>fr", function()
    snacks.picker.recent()
  end, { desc = "Recent Files" })

  map("n", "<leader>fB", function()
    snacks.picker.buffers()
  end, { desc = "Buffers" })

  -- Search functionality
  map("n", "<leader>/", function()
    snacks.picker.grep(monorepo_opts)
  end, { desc = "Grep" })

  map("n", "<leader>sg", function()
    snacks.picker.grep(monorepo_opts)
  end, { desc = "Grep" })

  map("n", "<leader>sw", function()
    snacks.picker.grep_string(monorepo_opts)
  end, { desc = "Grep Word" })

  -- Command and help search
  map("n", "<leader>sc", function()
    snacks.picker.commands()
  end, { desc = "Commands" })

  map("n", "<leader>sh", function()
    snacks.picker.help()
  end, { desc = "Help Pages" })

  map("n", "<leader>sk", function()
    snacks.picker.keymaps()
  end, { desc = "Key Maps" })

  map("n", "<leader>ss", function()
    snacks.picker.files()
  end, { desc = "Select Files" })

  map("n", "<leader>sa", function()
    snacks.picker.autocmds()
  end, { desc = "Auto Commands" })

  map("n", "<leader>sb", function()
    snacks.picker.lines()
  end, { desc = "Buffer Lines" })

  map("n", "<leader>:", function()
    snacks.picker.command_history()
  end, { desc = "Command History" })

  map("n", "<leader>sR", function()
    snacks.picker.resume()
  end, { desc = "Resume" })

  -- Git integration (Basic pickers)
  map("n", "<leader>gc", function()
    snacks.picker.git_log()
  end, { desc = "Git Commits" })

  map("n", "<leader>gs", function()
    snacks.picker.git_status()
  end, { desc = "Git Status" })

  -- Note: Enhanced git pickers are loaded by git.enhanced plugin:
  -- <leader>gd - Git diff files (vs release)
  -- <leader>gD - Git diff files (vs custom branch)
  -- <leader>gh - Git hunks picker

  -- LSP symbol search (global)
  map("n", "<leader>sS", function()
    snacks.picker.lsp_workspace_symbols()
  end, { desc = "Workspace Symbols" })

  -- Test file commands
  map("n", "<leader>ft", function()
    snacks.picker.files({
      args = {
        "--type=file",
        "--hidden",
        "--follow",
        "--exclude",
        "node_modules",
        "--exclude",
        ".git",
        "\\.(test|spec)\\.(js|ts|jsx|tsx)$|_test\\.dart$|_spec\\.dart$",
      },
    })
  end, { desc = "Find Test Files" })

  map("n", "<leader>st", function()
    snacks.picker.grep({
      args = build_grep_args({
        "*.test.{js,ts,jsx,tsx}",
        "*.spec.{js,ts,jsx,tsx}",
        "*_test.dart",
        "*_spec.dart",
      }),
    })
  end, { desc = "Search in Test Files" })

  -- Bloc/Cubit file commands
  map("n", "<leader>fb", function()
    snacks.picker.files({
      args = {
        "--type=file",
        "--hidden",
        "--follow",
        "--exclude",
        "node_modules",
        "--exclude",
        ".git",
        "([Bb]loc|[Cc]ubit)\\.(ts|tsx|js|jsx)$|_bloc\\.dart$|_cubit\\.dart$",
      },
    })
  end, { desc = "Find Bloc/Cubit Files" })

  map("n", "<leader>sB", function()
    snacks.picker.grep({
      args = build_grep_args({
        "*[Bb]loc.{js,ts,jsx,tsx}",
        "*[Cc]ubit.{js,ts,jsx,tsx}",
        "*_bloc.dart",
        "*_cubit.dart",
      }),
    })
  end, { desc = "Search in Bloc/Cubit Files" })

  -- Show all files including tests
  map("n", "<leader>fT", function()
    snacks.picker.files({
      args = build_file_args(constants.COMMON_EXCLUDES),
    })
  end, { desc = "Find All Files (Including Tests)" })

  -- Feature files (implementation + tests + bloc/cubit for a feature)
  map("n", "<leader>fF", function()
    vim.ui.input({ prompt = "Feature name: " }, function(feature)
      if not feature or feature == "" then
        return
      end
      snacks.picker.files({
        args = {
          "--type=file",
          "--hidden",
          "--follow",
          "--exclude",
          "node_modules",
          "--exclude",
          ".git",
          feature,
        },
      })
    end)
  end, { desc = "Find Feature Files" })

  return true
end

return M
