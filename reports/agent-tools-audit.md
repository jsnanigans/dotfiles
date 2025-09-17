# Investigation: Agent Tool Configuration Audit

## Bottom Line
**Root Cause**: Tool assignments don't match agent responsibilities - investigator lacks write capability for reports, planner has unnecessary edit tool, quick-build missing essential search tools
**Fix Location**: `opencode/agent/*.md` frontmatter sections
**Confidence**: High

## What's Happening
Agent tool configurations are misaligned with their documented responsibilities. The investigator can't write reports despite being required to, planner has code editing tools despite being planning-only, and quick-build lacks comprehensive search capabilities.

## Why It Happens
**Primary Cause**: Tool configurations were likely copied from a template without considering each agent's specific needs
**Trigger**: `opencode/agent/investigator.md:7-8` - write/edit disabled for investigator
**Decision Point**: `opencode/agent/planner.md:8` - edit enabled for planner (planning-only agent)

## Evidence
- **Key File**: `opencode/agent/investigator.md:30-31` - States "ALWAYS create/write report" but write:false
- **Key File**: `opencode/agent/planner.md:43` - States "Planning-only. No code changes" but edit:true
- **Key File**: `opencode/agent/quick-build.md:14-15` - Missing webfetch/web-search despite needing context

## Next Steps
1. Enable write tool for investigator (required for reports)
2. Remove edit tool from planner (planning-only agent)
3. Add task tool to all agents for delegation capabilities

## Risks
- Investigator cannot fulfill core mission without write capability
- Planner could accidentally modify code against its charter
- Agents lack ability to delegate complex subtasks
