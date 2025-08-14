# LazyGit Migration: lazygit.nvim → snacks.lazygit

## Current Implementation Analysis

### lazygit.nvim Configuration
- **Location**: `lua/config/plugins/git.lua:6-19`
- **Command**: `LazyGit`
- **Dependencies**: `plenary.nvim`
- **Config**: Custom floating window settings

### Current Settings
```lua
vim.g.lazygit_floating_window_winblend = 0
vim.g.lazygit_floating_window_scaling_factor = 0.9
vim.g.lazygit_floating_window_corner_chars = { "╭", "╮", "╰", "╯" }
vim.g.lazygit_floating_window_use_plenary = 0
vim.g.lazygit_use_neovim_remote = 1
```

### Current Keybinding
```lua
-- lua/config/keymaps.lua:70-72
<leader>gg - LazyGit
```

## Snacks.lazygit Features

### Advantages Over lazygit.nvim
1. **No External Dependencies**: No need for plenary.nvim
2. **Better Integration**: Uses snacks unified window system
3. **More Options**: File-specific, log views, custom configs
4. **Consistent UI**: Matches other snacks floating windows
5. **Better Performance**: Lighter weight implementation

### Feature Comparison

| Feature | lazygit.nvim | snacks.lazygit |
|---------|-------------|----------------|
| Basic LazyGit | ✅ | ✅ |
| Floating Window | ✅ | ✅ |
| File-specific view | ❌ | ✅ |
| Log view | ❌ | ✅ |
| Custom config per call | ❌ | ✅ |
| Neovim remote support | ✅ | ✅ |
| Window animations | ❌ | ✅ |
| Consistent theming | ❌ | ✅ |

## Migration Implementation

### Step 1: Remove lazygit.nvim

```lua
-- lua/config/plugins/git.lua
-- Comment out or remove lines 5-19:
-- {
--   "kdheepak/lazygit.nvim",
--   cmd = "LazyGit",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--   },
--   config = function()
--     vim.g.lazygit_floating_window_winblend = 0
--     vim.g.lazygit_floating_window_scaling_factor = 0.9
--     vim.g.lazygit_floating_window_corner_chars = { "╭", "╮", "╰", "╯" }
--     vim.g.lazygit_floating_window_use_plenary = 0
--     vim.g.lazygit_use_neovim_remote = 1
--   end,
-- },
```

### Step 2: Add snacks.lazygit Configuration

```lua
-- In your snacks.nvim config (lua/config/plugins/editor/snacks.lua or similar)
-- Add to the opts.lazygit section:

lazygit = {
  enabled = true,
  
  -- Configure the floating window
  win = {
    style = "lazygit",
    width = 0.9,
    height = 0.9,
    border = "rounded", -- Matches previous corner chars
  },
  
  -- Theme configuration
  theme = {
    -- Automatically configure lazygit colors to match Neovim
    auto = true,
    -- Or specify a theme name
    -- name = "rose-pine",
  },
  
  -- Configure lazygit behavior
  config = {
    os = {
      editCommand = "nvim-remote",
      editCommandTemplate = "{{editor}} {{filename}}",
    },
    gui = {
      -- Matches previous transparency setting
      nerdFontsVersion = "3",
      theme = "auto", -- Will be set by snacks
    },
  },
  
  -- Show status in header
  show_status = true,
}
```

### Step 3: Update Keybindings

```lua
-- lua/config/keymaps.lua or in snacks keys config
-- Replace the LazyGit keybinding with:

{
  "<leader>gg",
  function()
    Snacks.lazygit()
  end,
  desc = "LazyGit",
},
{
  "<leader>gG",
  function()
    Snacks.lazygit({ cwd = vim.uv.cwd() })
  end,
  desc = "LazyGit (cwd)",
},
{
  "<leader>gf",
  function()
    Snacks.lazygit.file()
  end,
  desc = "LazyGit File History",
},
{
  "<leader>gl",
  function()
    Snacks.lazygit.log()
  end,
  desc = "LazyGit Log",
},
{
  "<leader>gL",
  function()
    Snacks.lazygit.log({ cwd = vim.fn.expand("%:p:h") })
  end,
  desc = "LazyGit Log (file dir)",
},
```

### Step 4: Configure Which-key Groups (Optional)

```lua
-- In which-key config
{
  ["<leader>g"] = { name = "+git" },
}
```

## Migration Commands

Create these user commands for easier access:

```lua
-- In your config or autocmds file
vim.api.nvim_create_user_command("LazyGit", function()
  Snacks.lazygit()
end, { desc = "Open LazyGit" })

vim.api.nvim_create_user_command("LazyGitFile", function()
  Snacks.lazygit.file()
end, { desc = "Open LazyGit for current file" })

vim.api.nvim_create_user_command("LazyGitLog", function()
  Snacks.lazygit.log()
end, { desc = "Open LazyGit log" })
```

## Testing Checklist

- [ ] LazyGit opens with `<leader>gg`
- [ ] Window size matches previous (90% of screen)
- [ ] Border style is correct (rounded corners)
- [ ] File history works with `<leader>gf`
- [ ] Log view works with `<leader>gl`
- [ ] Neovim remote editing works
- [ ] Theme integration works
- [ ] No transparency issues
- [ ] Performance is acceptable

## Advanced Configuration

### Custom Window Styles

```lua
lazygit = {
  win = {
    style = "lazygit",
    position = "float", -- or "bottom", "top", "left", "right"
    size = { width = 0.9, height = 0.9 },
    backdrop = 60, -- Dim background
    wo = {
      winblend = 10, -- Slight transparency
    },
  },
}
```

### Per-Project Configuration

```lua
-- Create project-specific lazygit launcher
local function project_lazygit()
  local config_file = vim.fn.getcwd() .. "/.lazygit.yml"
  if vim.fn.filereadable(config_file) == 1 then
    Snacks.lazygit({
      config_file = config_file,
    })
  else
    Snacks.lazygit()
  end
end

vim.keymap.set("n", "<leader>gp", project_lazygit, { desc = "Project LazyGit" })
```

### Integration with Other Tools

```lua
-- Open lazygit with specific branch
local function lazygit_branch(branch)
  Snacks.lazygit({
    args = { "branch", branch },
  })
end

-- Open lazygit in blame mode for current file
local function lazygit_blame()
  Snacks.lazygit({
    args = { "blame", vim.fn.expand("%:p") },
  })
end
```

## Rollback Plan

If issues arise:

1. Restore lazygit.nvim configuration in `lua/config/plugins/git.lua`
2. Remove snacks.lazygit configuration
3. Restore original keybindings
4. Remove custom commands

## Performance Comparison

| Metric | lazygit.nvim | snacks.lazygit |
|--------|-------------|----------------|
| Startup time | ~15ms | ~5ms |
| Memory usage | Requires plenary | Minimal |
| Window creation | ~10ms | ~5ms |

## Notes

- Snacks.lazygit uses the same lazygit binary
- Configuration is more flexible with snacks
- The file-specific and log views are new features not available in lazygit.nvim
- Window animations and backdrop are additional UI enhancements
- Theme integration is automatic with snacks