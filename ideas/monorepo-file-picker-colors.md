# Monorepo File Picker Color Coding

## Problem Statement

When working in a monorepo with multiple apps and packages, the file picker (triggered by `<space>ff`) shows files from different projects but it's hard to quickly identify which app/package a file belongs to because the important path segments (e.g., `apps/user-app`, `apps/pmp`, `packages/ui`) are often truncated or not immediately visible.

## Desired Solution

Add visual indicators to files in the snacks.nvim picker to distinguish between different monorepo projects:

1. **Color-coded project tags**: Each `apps/*` and `packages/*` project gets a unique, consistent color
2. **Project name prefix**: Show `[project-name]` before each file
3. **Unique symbols/icons**: Replace generic file icons with project-specific symbols
4. **Hash-based consistency**: Use path hashing to ensure the same project always gets the same color/symbol

### Example Display
Instead of:
```
TaskList.tsx  apps/.../components/UserTasks/
TaskList.tsx  apps/.../components/TaskList/
TaskList.tsx  packages/.../
```

Show:
```
󰏆 [user-app] TaskList.tsx  apps/.../components/UserTasks/
󰏈 [pmp] TaskList.tsx  apps/.../components/TaskList/
󰏉 [ui] TaskList.tsx  packages/.../
```

Where each project has a unique color and symbol.

## Implementation Challenges

### Attempted Approaches

1. **Global formatter configuration** - Tried setting formatters in snacks-full.lua config
   - Issue: Formatter wasn't being applied to picker instances

2. **Custom format function** - Passed format function directly to picker.files()
   - Issue: The format function worked with simple additions but broke when accessing item.file properties

3. **Custom formatter preset** - Registered custom formatter and referenced by name
   - Issue: Formatter registration didn't work as expected

4. **Transform function** - Used transform option to modify items before display
   - Issue: Transform didn't affect visual display

### Technical Limitations

The snacks.nvim picker API has specific requirements:
- `format` parameter expects a string preset name, not a function
- Formatters return arrays of segments with specific structure `{text, highlight, options}`
- The item structure and how formatters interact with it isn't fully documented
- Direct format function override works for simple cases (like adding "TEST" prefix) but fails with more complex logic

## Working Example

The only approach that worked was passing a simple format function directly:
```lua
snacks.picker.files({
  args = standard_file_args,
  format = function(picker, item)
    local formatted = require("snacks.picker.format").file(item, picker)
    table.insert(formatted, 1, { "🔴 TEST ", "Error", virtual = true })
    return formatted
  end,
})
```

But this broke when trying to access `item.file` or modify the formatted segments based on file paths.

## Future Considerations

1. **Fork/extend snacks.nvim** to properly support custom formatters for this use case
2. **Use a different picker** that has more flexible formatting options
3. **Create wrapper functions** that pre-process items before passing to the picker
4. **Submit feature request** to snacks.nvim for better monorepo support

## Related Files

- `/Users/brendanmullins/dotfiles/nvim/marvim/lua/config/keymaps/search.lua` - Contains the picker keybindings
- `/Users/brendanmullins/dotfiles/nvim/marvim/lua/config/plugins/editor/snacks-full.lua` - Snacks.nvim configuration