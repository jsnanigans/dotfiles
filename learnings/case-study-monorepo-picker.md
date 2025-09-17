# Case Study: Monorepo File Picker Feature

## The Problem

In a monorepo with multiple apps and packages, the file picker shows files from different projects but it's hard to identify which app/package a file belongs to. We wanted to add colored project tags like `[user-app]` or `[ui]` before each file.

## Evolution of the Solution

### Attempt 1: Hardcoded Solution (Too Specific)

```lua
-- Added directly to format.lua
function M.monorepo(item, picker)
  if item.file:match("apps/") then
    -- Hardcoded monorepo logic
  end
end
```

**Problems:**
- Only works for monorepos
- Hardcoded patterns
- Not configurable

### Attempt 2: Generic Decorator Framework (Too Complex)

```lua
-- 150+ lines of framework code
function M.decorate(item, picker, decorator_name)
  local config = picker.opts.decorators[decorator_name]
  local value = config.extract(item, picker)
  local style = config.style(value, context, item, picker)
  local cache_key = config.cache_key(value, context, decorator_name)
  -- ... more abstraction ...
end
```

**Problems:**
- Over-engineered
- Too many configuration options
- Doesn't match existing patterns
- Confusing API

### Attempt 3: Standalone Formatter (Better, But Not Integrated)

```lua
function M.path_segment(item, picker)
  local config = picker.opts.formatters.path_segment
  -- Standalone implementation
end
```

**Problems:**
- Doesn't compose with other formatters
- Still has multiple configuration methods
- Separate from file formatter where it logically belongs

### Final Solution: Integrated into File Formatter (Perfect)

```lua
-- Added to existing M.file() formatter
if item.file and picker.opts.formatters.file.path_segment then
  local cfg = picker.opts.formatters.file.path_segment
  if cfg.enabled ~= false then
    for _, pattern in ipairs(cfg.patterns or {}) do
      local ok, segment = pcall(string.match, item.file, pattern)
      if ok and segment then
        local text = cfg.format and cfg.format:format(segment) or ("[" .. segment .. "] ")
        ret[#ret + 1] = { text, cfg.hl or "Comment", virtual = true }
        break
      end
    end
  end
end
```

**Why it's perfect:**
- 13 lines of code
- Integrates with existing file formatter
- Simple configuration
- Error handling with pcall
- Follows existing patterns exactly

## Configuration Examples

### Simple (Built-in Feature)

```lua
formatters = {
  file = {
    path_segment = {
      enabled = true,
      patterns = { "apps/([^/]+)", "packages/([^/]+)" },
      format = "[%s] ",
      hl = "Comment",
    }
  }
}
```

### Complex (Custom Formatter)

```lua
-- User writes custom formatter for advanced needs
format = function(item, picker)
  local ret = {}
  -- Hash-based color assignment
  -- Caching logic
  -- Custom formatting
  return ret
end
```

## Lessons Learned

1. **Start specific, then generalize only as needed**
   - We went too far with the decorator framework
   - The right level of generalization was simple pattern matching

2. **Integration beats separation**
   - path_segment belongs in the file formatter, not standalone
   - Composition is powerful

3. **Simple config for simple cases, custom code for complex cases**
   - Don't try to configuration everything
   - Let users write code when they need complexity

4. **Follow existing patterns**
   - The file formatter already had precedent (severity, status, etc.)
   - We should have noticed this pattern earlier

5. **Code reviews are invaluable**
   - Each review pushed us toward simplicity
   - Acting as our own maintainer helped us see issues

## The Final Diff

```diff
+ 13 lines in format.lua (inside existing M.file function)
+ 7 lines in defaults.lua (configuration example)
```

Total: 20 lines to solve the problem completely.

Compare to our decorator framework: 200+ lines that didn't even solve it well.

## Key Takeaway

The best code is not the code that handles every possible case, but the code that handles the actual cases elegantly and lets users handle their special cases themselves.