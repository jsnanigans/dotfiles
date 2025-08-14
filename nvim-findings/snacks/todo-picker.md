# TODO Comments Migration: todo-comments.nvim → snacks picker patterns

## Current Implementation Analysis

### todo-comments.nvim Configuration
- **Location**: `lua/config/plugins/coding.lua:17-24`
- **Events**: `BufReadPost`, `BufNewFile`, `BufWritePre`
- **Config**: Default (config = true)
- **Commands**: `TodoTrouble`

### Current Keybindings
```lua
-- lua/config/keymaps/plugins.lua:273-302
]t - Next Todo Comment
[t - Previous Todo Comment
<leader>xt - Todo (Trouble)
<leader>xT - Todo/Fix/Fixme (Trouble)
<leader>st - Search all TODO comments (already using snacks!)
<leader>sT - Search TODO/FIX/FIXME (already using snacks!)
```

### Current Hybrid Approach
You're already partially using snacks.picker for TODO searching! The migration would complete this transition.

## Feature Comparison

| Feature | todo-comments.nvim | snacks picker |
|---------|-------------------|---------------|
| Highlight TODOs in code | ✅ | ❌ |
| Jump next/prev | ✅ | ⚠️ (via quickfix) |
| Search TODOs | ✅ | ✅ |
| Custom keywords | ✅ | ✅ |
| Custom colors | ✅ | ❌ |
| Telescope/Trouble integration | ✅ | ⚠️ |
| Sign column icons | ✅ | ❌ |
| Pattern-based search | ✅ | ✅ |

## Migration Strategy

### Option 1: Full Migration (Lose highlighting)

Remove todo-comments.nvim completely and use snacks.picker for all TODO functionality.

**Pros:**
- One less dependency
- Consistent search interface
- Faster startup

**Cons:**
- Lose inline TODO highlighting
- Lose sign column icons
- Lose next/prev navigation

### Option 2: Hybrid Approach (Recommended)

Keep todo-comments.nvim for highlighting, use snacks.picker for searching.

**Pros:**
- Keep visual TODO highlights
- Better search interface with snacks
- Preserve all functionality

**Cons:**
- Keep the dependency

### Option 3: Custom Implementation

Create a minimal TODO highlighting solution and use snacks for search.

## Implementation

### Option 1: Full Migration

```lua
-- Step 1: Remove todo-comments.nvim from lua/config/plugins/coding.lua
-- Comment out lines 16-24

-- Step 2: Enhance snacks picker configuration
-- In snacks.nvim config:
picker = {
  -- Custom TODO patterns
  todo_patterns = {
    -- High priority
    { pattern = "FIXME|FIX|BUG|ISSUE", name = "fix", icon = "🔴" },
    -- Medium priority  
    { pattern = "TODO|HACK|WARN|WARNING", name = "todo", icon = "🟡" },
    -- Low priority
    { pattern = "NOTE|INFO|PERF|OPTIMIZE", name = "note", icon = "🔵" },
    -- Questions
    { pattern = "QUESTION|HELP|WTF", name = "question", icon = "❓" },
  },
}

-- Step 3: Create comprehensive keybindings
M.todo_picker_keys = {
  -- Search all TODOs
  {
    "<leader>st",
    function()
      Snacks.picker.grep({
        pattern = "TODO|HACK|PERF|NOTE|FIX|FIXME|WARNING|BUG|ISSUE|QUESTION",
        flags = "--case-sensitive",
        prompt_title = "TODO Comments",
      })
    end,
    desc = "Search TODOs",
  },
  
  -- Search high priority only
  {
    "<leader>sT", 
    function()
      Snacks.picker.grep({
        pattern = "FIXME|FIX|BUG|ISSUE",
        flags = "--case-sensitive",
        prompt_title = "Fix/Bug Comments",
      })
    end,
    desc = "Search FIX/BUG",
  },
  
  -- Search in current file
  {
    "<leader>stf",
    function()
      Snacks.picker.grep({
        pattern = "TODO|HACK|PERF|NOTE|FIX|FIXME",
        flags = "--case-sensitive",
        search_dirs = { vim.fn.expand("%:p") },
        prompt_title = "TODOs in Current File",
      })
    end,
    desc = "TODOs in File",
  },
  
  -- Navigate via quickfix
  {
    "]t",
    function()
      -- Populate quickfix with TODOs and jump to next
      vim.cmd([[silent grep -E "TODO|FIXME|FIX|HACK" %]])
      vim.cmd("cnext")
    end,
    desc = "Next TODO",
  },
  {
    "[t",
    function()
      vim.cmd("cprev")
    end,
    desc = "Previous TODO",
  },
}
```

### Option 2: Hybrid Approach (Recommended)

```lua
-- Keep todo-comments.nvim but simplify config
{
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- Minimal config - just for highlighting
    signs = true,
    sign_priority = 8,
    keywords = {
      FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "ISSUE" } },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    },
    -- Disable search integration since we use snacks
    search = {
      command = false,
      pattern = false,
    },
  },
  -- Only keep navigation keys
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo" },
  },
}

-- Use snacks.picker for all searching (already configured)
```

### Option 3: Custom Minimal Highlighting

```lua
-- Create a minimal TODO highlighter
-- In lua/config/autocmds.lua or similar:

local function setup_todo_highlights()
  -- Define highlight groups
  vim.api.nvim_set_hl(0, "TodoFix", { fg = "#ff6c6b", bold = true })
  vim.api.nvim_set_hl(0, "TodoWarn", { fg = "#ECBE7B", bold = true })
  vim.api.nvim_set_hl(0, "TodoInfo", { fg = "#51afef", bold = true })
  vim.api.nvim_set_hl(0, "TodoHint", { fg = "#98be65", bold = true })
  
  -- Define patterns
  local patterns = {
    { pattern = [[\v(FIXME|FIX|BUG|ISSUE):?]], group = "TodoFix" },
    { pattern = [[\v(TODO|HACK):?]], group = "TodoWarn" },
    { pattern = [[\v(NOTE|INFO):?]], group = "TodoInfo" },
    { pattern = [[\v(PERF|OPTIMIZE):?]], group = "TodoHint" },
  }
  
  -- Apply syntax matches
  for _, match in ipairs(patterns) do
    vim.fn.matchadd(match.group, match.pattern)
  end
end

-- Apply to all buffers
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = setup_todo_highlights,
})
```

## Testing Checklist

### For Full Migration
- [ ] TODO search works with all patterns
- [ ] File-specific TODO search works
- [ ] Quickfix navigation works
- [ ] No errors on startup
- [ ] Acceptable loss of highlighting

### For Hybrid Approach
- [ ] TODOs are highlighted in code
- [ ] Navigation with ]t/[t works
- [ ] Search with snacks works
- [ ] No duplicate functionality
- [ ] Clean integration

### For Custom Implementation
- [ ] Basic highlighting works
- [ ] All TODO patterns recognized
- [ ] Search integration works
- [ ] Performance is good

## Advanced Patterns

### Project-Specific TODOs

```lua
-- Search for TODOs by author
{
  "<leader>stm",
  function()
    local author = vim.fn.input("Author: ")
    if author ~= "" then
      Snacks.picker.grep({
        pattern = string.format("TODO.*%s|FIXME.*%s", author, author),
        prompt_title = "TODOs by " .. author,
      })
    end
  end,
  desc = "TODOs by Author",
}

-- Search for dated TODOs
{
  "<leader>std",
  function()
    Snacks.picker.grep({
      pattern = "TODO.*2024|FIXME.*2024",
      prompt_title = "Dated TODOs",
    })
  end,
  desc = "Dated TODOs",
}
```

### Integration with Quickfix

```lua
-- Populate quickfix with all TODOs
local function todos_to_quickfix()
  local cmd = "rg --vimgrep 'TODO|FIXME|FIX|HACK|NOTE' ."
  local results = vim.fn.systemlist(cmd)
  
  local qf_list = {}
  for _, line in ipairs(results) do
    local filename, lnum, col, text = line:match("([^:]+):(%d+):(%d+):(.+)")
    if filename then
      table.insert(qf_list, {
        filename = filename,
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = text,
      })
    end
  end
  
  vim.fn.setqflist(qf_list)
  vim.cmd("copen")
end

vim.keymap.set("n", "<leader>stq", todos_to_quickfix, { desc = "TODOs to Quickfix" })
```

## Recommendation

**Use Option 2 (Hybrid Approach)** because:
1. You keep the visual TODO highlighting that's valuable for development
2. You already use snacks.picker for searching
3. Minimal configuration overhead
4. Best of both worlds

The full migration (Option 1) only makes sense if you:
- Want to minimize dependencies at all costs
- Don't value inline TODO highlighting
- Prefer a unified tool approach

## Notes

- Snacks.picker provides better search UX than todo-comments
- The hybrid approach is already partially implemented in your config
- Consider keeping todo-comments for highlighting only
- Custom highlighting is an option but adds maintenance burden