# Agent Tools Audit Report

## Current vs Recommended Tool Permissions

### Investigator Agent
**Purpose**: Deep investigation specialist for understanding system behaviors

**Current Tools**: Read, Bash, Grep, Glob, WebFetch, mcp__web-search__brave_web_search

**Issues Found**:
- Missing `Task` - Needed for delegating complex multi-step investigations
- Missing `TodoWrite` - Important for tracking investigation steps systematically

**Recommended Tools**: Read, Bash, Grep, Glob, WebFetch, Task, TodoWrite, mcp__web-search__brave_web_search

### Planner Agent
**Purpose**: Planning agent for implementation/fix/feature designs

**Current Tools**: Read, Write, Edit, Bash, WebFetch, mcp__web-search__brave_web_search

**Issues Found**:
- Has `Edit` but shouldn't - Planner is planning-only, no code modifications
- Missing `Grep` - Essential for understanding codebase structure
- Missing `Glob` - Needed for discovering files when planning
- Missing `TodoWrite` - Critical for creating structured implementation plans
- Missing `Task` - Useful for delegating investigation needs

**Recommended Tools**: Read, Write, Bash, Grep, Glob, WebFetch, Task, TodoWrite, mcp__web-search__brave_web_search

### Quick-Build Agent
**Purpose**: Fast execution of planned changes

**Current Tools**: Read, Write, Edit, Bash, Grep, Glob

**Issues Found**:
- Missing `MultiEdit` - Essential for atomic multi-file changes
- Missing `TodoWrite` - Important for tracking implementation progress
- Missing `NotebookEdit` - Needed if working with Jupyter notebooks

**Recommended Tools**: Read, Write, Edit, MultiEdit, NotebookEdit, Bash, Grep, Glob, TodoWrite

## Summary of Changes

1. **Investigator**: Add Task, TodoWrite for better investigation management
2. **Planner**: Remove Edit, add Grep, Glob, Task, TodoWrite for better planning capabilities
3. **Quick-Build**: Add MultiEdit, NotebookEdit, TodoWrite for more efficient implementation

## Rationale

- **TodoWrite** is critical for all agents to track their progress and plan steps
- **Task** helps investigator and planner delegate complex sub-investigations
- **MultiEdit** is essential for quick-build to make atomic changes across files
- **Planner** should never edit code directly (planning-only principle)
- **Grep/Glob** are fundamental for understanding codebase structure