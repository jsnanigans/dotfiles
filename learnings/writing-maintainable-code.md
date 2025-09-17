# Lessons from snacks.nvim: Writing Maintainable Code

## Our Journey: From Over-Engineering to Simplicity

We started with a "monorepo file coloring" feature and went through several iterations:

1. **First attempt**: Monorepo-specific implementation hardcoded in plugin
2. **Second attempt**: Generic decorator framework with extract/style/cache/transform
3. **Third attempt**: Standalone formatter with multiple configuration methods
4. **Final solution**: 13 lines integrated into existing file formatter

Each iteration taught us valuable lessons about code design.

## Key Learnings

### 1. **Follow Existing Patterns Religiously**

**What we learned:**
```lua
-- BAD: We created a new pattern
function M.decorate(item, picker, decorator_name)  -- Takes a string param?
  local config = picker.opts.decorators[decorator_name]  -- New config section?
  -- Complex framework...
end

-- GOOD: Follow existing patterns
function M.path_segment(item, picker)  -- Same signature as all formatters
  local config = picker.opts.formatters.path_segment  -- Uses existing config structure
  -- Simple implementation...
end
```

**Why it matters:**
- Developers already understand the existing patterns
- Consistency reduces cognitive load
- Documentation is simpler
- Testing follows established patterns

### 2. **Resist the Urge to Build Frameworks**

**What we learned:**
```lua
-- BAD: We built a decorator framework
{
  extract = function(...) end,
  style = function(...) end,
  cache_key = function(...) end,
  transform = function(...) end,
}

-- GOOD: Simple configuration
{
  patterns = { "apps/([^/]+)" },
  format = "[%s] ",
  hl = "Comment",
}
```

**The Framework Trap:**
- Starts with "what if someone wants to..."
- Adds abstraction layers for hypothetical use cases
- Creates complexity that 99% of users won't need
- Makes simple things hard

**The Simple Solution:**
- Solves the actual problem at hand
- Users who need complexity can write custom functions
- Easy to understand, maintain, and debug

### 3. **Provide ONE Way to Do Things**

**What we learned:**
```lua
-- BAD: Multiple ways to achieve the same thing
if config.extract then
  -- Custom extraction
elseif config.patterns then
  -- Pattern matching
end

if config.style then
  -- Style function
elseif config.format then
  -- Format function
else
  -- Default formatting
end

-- GOOD: One clear path
for _, pattern in ipairs(config.patterns or {}) do
  -- Only one way to extract
end
local text = config.format and config.format:format(segment) or default
-- Only one way to format
```

**Why one way is better:**
- Reduces decision fatigue
- Easier to document
- Fewer bugs (less code paths)
- Clear expectations

### 4. **Keep Configuration Flat and Simple**

**What we learned:**
```lua
-- BAD: Complex nested configuration
decorators = {
  path = {
    extract = function(...) end,
    style = {
      colors = [...],
      icons = [...],
    },
    cache = {
      enabled = true,
      key = function(...) end,
    }
  }
}

-- GOOD: Flat, simple configuration
file = {
  path_segment = {
    enabled = true,
    patterns = { "apps/([^/]+)" },
    format = "[%s] ",
    hl = "Comment",
  }
}
```

**Benefits:**
- Self-documenting
- Type-checkable
- Easy to validate
- No surprises

### 5. **Compose, Don't Complicate**

**What we learned:**
```lua
-- BAD: Separate formatter that doesn't compose
M.path_segment()  -- Standalone
M.file()          -- Can't work together with path_segment

-- GOOD: Integrated where it belongs
function M.file(item, picker)
  -- ... existing file formatting ...

  -- Path segment is just another part of file formatting
  if picker.opts.formatters.file.path_segment then
    -- Add path segment
  end

  -- ... continue with file formatting ...
end
```

**Why composition matters:**
- Features work together naturally
- No ordering issues
- No duplicate code
- Predictable behavior

### 6. **Error Handling Without Complexity**

**What we learned:**
```lua
-- BAD: Let it crash
segment = item.file:match(pattern)  -- Can throw error

-- GOOD: Simple, safe
local ok, segment = pcall(string.match, item.file, pattern)
if ok and segment then
  -- Use segment
end
```

**The balance:**
- Handle errors that are likely (bad patterns)
- Don't over-engineer for impossible scenarios
- Keep error handling local and simple

### 7. **Performance Through Simplicity**

**What we learned:**
```lua
-- BAD: Complex caching system
local cache = {}
local function get_cached_style(key)
  if not cache[key] then
    cache[key] = complex_calculation()
  end
  return cache[key]
end

-- GOOD: Let the user handle it if needed
-- No caching in the plugin
-- Users who need caching can do it in their custom formatter
```

**Why simple is often faster:**
- Less code to execute
- Fewer allocations
- No cache invalidation bugs
- No memory leaks

## Universal Principles

### The KISS Principle Applied

**Keep It Simple, Stupid** - but what does that mean in practice?

1. **Start with the simplest solution that could possibly work**
   - Our 13-line solution does exactly what's needed
   - No more, no less

2. **Add complexity only when proven necessary**
   - We don't need a framework until multiple real use cases prove it
   - YAGNI (You Aren't Gonna Need It)

3. **Make the common case easy, the complex case possible**
   - Simple config for common case: `patterns = {...}, format = "[%s]"`
   - Custom formatter function for complex cases

### The Maintainer's Mindset

When writing code, ask yourself:

1. **"Would I want to maintain this in 2 years?"**
   - Will I remember how this works?
   - Can a new developer understand it quickly?

2. **"Does this fit with what's already there?"**
   - Same patterns?
   - Same conventions?
   - Same level of abstraction?

3. **"Am I solving a real problem or a hypothetical one?"**
   - Do users actually need this flexibility?
   - Is the complexity worth it?

4. **"Can this be simpler?"**
   - Remove features until it breaks, then add back the last one
   - Every line should earn its place

### Code Review as Learning

Our multiple reviews taught us:

1. **First review**: "This is too specific" → Make it generic
2. **Second review**: "This is too complex" → Simplify the API
3. **Third review**: "Too many options" → One way to do things
4. **Final review**: "Should be part of existing formatter" → Compose, don't separate

Each review made the code better by making it simpler.

## The Final Test

Good code passes the **"Obvious Test"**:
- When you look at it, you think "of course, how else would you do it?"
- It seems inevitable, not clever
- Anyone could have written it (but it takes experience to know what to NOT write)

Our final 13-line solution passes this test. It's so simple it's almost boring - and that's perfect.

## Applying These Lessons

Whether you're adding to snacks.nvim, contributing to any project, or building your own:

1. **Study existing patterns first** - Spend more time reading than writing
2. **Start simple** - You can always add complexity later
3. **Get feedback early** - Show your simple solution before building the framework
4. **Be willing to delete code** - We deleted hundreds of lines to get to 13
5. **Optimize for readability** - Code is read 100x more than written
6. **Trust the user** - They can write custom code for custom needs

The path from complex to simple is not a failure - it's learning. Every codebase benefits from developers who've learned when NOT to write code.