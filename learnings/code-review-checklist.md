# Code Review Checklist

Based on our snacks.nvim experience, here's a checklist for reviewing code (your own or others').

## Before Writing Code

- [ ] **Have I read the existing code thoroughly?**
  - Understand current patterns
  - Find similar features
  - Check conventions

- [ ] **Is there a simpler solution?**
  - Start with the simplest thing that could work
  - Add complexity only when proven necessary

- [ ] **Am I solving a real problem?**
  - Not a hypothetical "what if someone wants to..."
  - Have actual use cases

## Architecture & Design

- [ ] **Does it follow existing patterns?**
  - Function signatures match similar functions
  - Configuration structure matches existing config
  - Same level of abstraction

- [ ] **Is there only ONE way to do things?**
  - No multiple configuration methods for same outcome
  - No redundant APIs
  - Clear, single path through the code

- [ ] **Does it compose with existing features?**
  - Works together with related features
  - No duplicate functionality
  - Predictable interactions

## Implementation

- [ ] **Is the configuration flat and simple?**
  ```lua
  -- Good
  { enabled = true, patterns = {...}, format = "..." }

  -- Bad
  { extract = fn, style = fn, transform = fn, cache = {...} }
  ```

- [ ] **Is error handling appropriate?**
  - Handle likely errors (bad input)
  - Don't over-engineer for impossible cases
  - Use pcall for user-provided patterns/regex

- [ ] **Am I building a framework?**
  - Red flag: Multiple abstraction layers
  - Red flag: Lots of configuration options
  - Red flag: "Extensible" or "flexible" in description

## Code Quality

- [ ] **Can I remove code?**
  - Remove features until it breaks
  - Add back only what's essential
  - Every line should justify its existence

- [ ] **Is it obvious?**
  - New developer can understand in 5 minutes
  - Doesn't feel "clever"
  - Seems like the inevitable solution

- [ ] **Would I want to maintain this?**
  - In 2 years, will I understand it?
  - Can I explain it simply?
  - Is debugging straightforward?

## Performance

- [ ] **Is complexity justified by performance needs?**
  - Don't add caching "just in case"
  - Profile before optimizing
  - Simple often performs better

- [ ] **Am I creating unnecessary allocations?**
  - Reuse tables where sensible
  - But don't sacrifice clarity for micro-optimizations

## Integration

- [ ] **Where does this belong?**
  - Part of existing module vs. new module
  - Consider where users would expect to find it
  - Group related functionality

- [ ] **How does configuration work?**
  - Consistent with existing config sections
  - Documented inline
  - Sensible defaults

## Final Questions

- [ ] **Can this be simpler?** (Ask 3 times)
- [ ] **Am I proud of how simple this is?** (Not how clever)
- [ ] **Would the maintainer merge this immediately?**

## Red Flags to Watch For

🚩 "This might be useful later"
🚩 "What if someone wants to..."
🚩 Multiple ways to configure the same thing
🚩 Deep nesting in config or code
🚩 Lots of options that interact in complex ways
🚩 Need for extensive documentation to explain it
🚩 Feels clever or innovative
🚩 "Framework" or "System" in your description
🚩 Cache without proven performance need
🚩 Abstract base classes or heavy inheritance

## Green Flags

✅ Looks obvious in retrospect
✅ Follows existing patterns exactly
✅ Minimal configuration
✅ Single responsibility
✅ Can explain in one sentence
✅ Deleting code made it better
✅ Boring but effective
✅ Small diff
✅ Works with existing features naturally
✅ Would be easy to debug

## The Ultimate Test

Show your code to someone unfamiliar with the codebase. If they can understand:
1. What it does
2. How to use it
3. Why it's implemented that way

...within 5 minutes, you've probably got it right.

## Remember

> "Perfection is achieved not when there is nothing more to add, but when there is nothing left to take away." - Antoine de Saint-Exupéry

The goal is not to handle every case, but to handle real cases elegantly and let users handle their special cases themselves.