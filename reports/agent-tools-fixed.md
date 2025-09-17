# Agent Tools Configuration - Fixed

## Summary of Changes

### Investigator Agent
**Added Tools:**
- `write: true` - Required for creating reports (was false, breaking core functionality)
- `task: true` - Can delegate complex searches to general agent
- `todowrite: true` - For tracking investigation steps
- `todoread: true` - For checking investigation progress

**Kept:** bash, read, grep, glob, list, webfetch, web-search
**Removed:** edit (investigators don't modify code)

### Planner Agent  
**Added Tools:**
- `grep: true` - For searching patterns and understanding codebase
- `glob: true` - For finding related files
- `list: true` - For exploring project structure
- `task: true` - Can delegate investigation to investigator agent
- `todowrite: true` - For tracking planning steps
- `todoread: true` - For checking planning progress

**Removed:**
- `edit: false` - Planning-only agent should not modify code

**Kept:** write, bash, read, webfetch, web-search

### Quick-Build Agent
**Added Tools:**
- `webfetch: true` - May need to check API docs during implementation
- `web-search_brave_web_search: true` - May need to search for implementation patterns
- `task: true` - Can delegate complex subtasks
- `todowrite: true` - For tracking implementation progress
- `todoread: true` - For checking implementation status

**Kept:** write, edit, bash, read, grep, glob, list

## Rationale

Each agent now has tools that match their documented responsibilities:

1. **Investigator**: Can now write reports (critical fix), track investigation progress, and delegate complex searches
2. **Planner**: No longer has edit capability (was violating planning-only constraint), has search tools for understanding codebase
3. **Quick-Build**: Has full implementation toolkit including web resources for looking up APIs/patterns during coding

## Verification

All agents now have:
- Core tools for their primary function
- Task delegation capability for complex subtasks  
- Todo tracking for managing multi-step workflows
- No unnecessary tools that could lead to scope creep

The tool configurations now properly support each agent's mission without allowing actions outside their defined scope.
