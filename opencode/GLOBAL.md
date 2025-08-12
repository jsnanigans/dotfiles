# Subagent Usage Guidelines

## IMPORTANT: Use Subagents Frequently and Proactively

Subagents are specialized, highly-efficient agents designed to handle specific types of tasks. You should use them **liberally and proactively** to maximize efficiency and quality. Think of them as your expert team members - delegate to them often!

## Available Subagents

### 🚀 simple-task-runner
**When to use:** IMMEDIATELY for any straightforward, well-defined task
- File operations (create, rename, move, delete)
- Text replacements across files
- Running commands
- Adding imports or dependencies
- Creating boilerplate code
- Applying systematic refactoring patterns
- Any task that doesn't require complex analysis

**Trigger phrases to watch for:**
- "Replace all..."
- "Create a file..."
- "Run this command..."
- "Add this import..."
- "Apply this change to all..."

**Example usage:**
```
Task(description="Replace function names", prompt="Replace all instances of 'getUserData' with 'fetchUserProfile' in the src directory", subagent_type="simple-task-runner")
```

### 🧪 test-runner
**When to use:** AUTOMATICALLY after any code implementation or bug fix
- After implementing new features
- After fixing bugs
- When user mentions tests or coverage
- After refactoring code
- When exploring a new codebase (to understand test setup)
- To validate changes work correctly

**Trigger phrases to watch for:**
- "Write tests for..."
- "Check if tests pass..."
- "Improve coverage..."
- Any code implementation (proactively suggest running tests!)

**Example usage:**
```
Task(description="Write and run tests", prompt="Write comprehensive tests for the new authentication module in src/auth.js and ensure all tests pass", subagent_type="test-runner")
```

### 📝 conversation-summarizer
**When to use:** PROACTIVELY after completing complex tasks
- After implementing a feature
- After a long debugging session
- After making architectural decisions
- When switching context to a new task
- At natural breakpoints in work
- When user asks "what did we do?"

**Trigger phrases to watch for:**
- "Summarize what we did..."
- "Document the changes..."
- After completing multiple related tasks
- Before ending a session

**Example usage:**
```
Task(description="Summarize session", prompt="Create a comprehensive summary of our debugging session and the performance optimizations we implemented", subagent_type="conversation-summarizer")
```

## Parallel Execution Strategy

**ALWAYS consider running multiple subagents in parallel when possible:**

```python
# Good - Parallel execution
Task(description="Replace old API", prompt="Replace all 'oldAPI' with 'newAPI' in src/", subagent_type="simple-task-runner")
Task(description="Update imports", prompt="Update all import statements from '@old/package' to '@new/package'", subagent_type="simple-task-runner")
Task(description="Test changes", prompt="Run all tests and ensure the API changes work correctly", subagent_type="test-runner")
```

## Decision Framework

Ask yourself these questions:
1. **Can this task be clearly defined in a single prompt?** → Use simple-task-runner
2. **Did I just write or modify code?** → Use test-runner
3. **Have we completed a significant piece of work?** → Use conversation-summarizer
4. **Can multiple independent tasks run simultaneously?** → Launch multiple subagents

## Proactive Patterns

### Pattern 1: Feature Implementation
1. User requests a feature
2. You implement the feature
3. **IMMEDIATELY** use test-runner to write/run tests
4. **THEN** use conversation-summarizer to document what was done

### Pattern 2: Bug Fix
1. User reports a bug
2. You fix the bug
3. **IMMEDIATELY** use test-runner to verify fix and prevent regression
4. **OPTIONALLY** use conversation-summarizer if it was complex

### Pattern 3: Refactoring
1. User requests refactoring
2. **FIRST** use test-runner to ensure tests pass
3. **THEN** use multiple simple-task-runners in parallel for systematic changes
4. **FINALLY** use test-runner again to verify nothing broke

### Pattern 4: Codebase Exploration
1. User asks about code structure
2. Use simple-task-runner to gather specific information
3. Use test-runner to understand test setup
4. Use conversation-summarizer to create a codebase overview

## Key Principles

1. **Delegate Early and Often** - Don't wait for permission to use subagents
2. **Parallelize When Possible** - Multiple subagents can work simultaneously
3. **Be Proactive** - Suggest using subagents even if not explicitly requested
4. **Trust the Specialists** - Subagents are optimized for their specific tasks
5. **Reduce Context** - Subagents help manage token usage efficiently

## Anti-Patterns to Avoid

❌ **DON'T** do simple find-and-replace manually - use simple-task-runner
❌ **DON'T** skip testing after code changes - always use test-runner
❌ **DON'T** wait for user to ask for tests - be proactive
❌ **DON'T** let complex sessions end without summarization
❌ **DON'T** try to do everything yourself when subagents can help

## Remember

**When in doubt, use a subagent!** They're designed to make your work faster, more reliable, and more efficient. The user will appreciate the thoroughness and speed that comes from proper delegation to specialized agents.
