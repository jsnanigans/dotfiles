# Investigation: Commented-Out Code Blocks in MARVIM

## Bottom Line

**Root Cause**: Minimal dead code found, most comments are documentation
**Fix Location**: 3 files with removable commented code
**Confidence**: High

## What's Happening

MARVIM configuration contains very little commented-out dead code. Most comment blocks are legitimate documentation, section dividers, or configuration examples. Only 3 locations have actual commented code that could be cleaned up.

## Why It Happens

**Primary Cause**: Normal development evolution
**Trigger**: Features disabled during testing or replaced with better alternatives
**Decision Point**: Developers left code for reference instead of removing

## Evidence

- **Key File**: `lua/config/plugins/editor/snacks-full.lua:167-181` - 15 disabled module configs
- **Search Used**: `rg "^\s*--.*\n\s*--.*\n\s*--.*" --multiline` - Found mostly documentation
- **File Check**: `lua/config/plugins/extras/debugging.lua:131` - Single commented debug option
- **Disabled File**: `lua/config/keymaps/snacks.lua.disabled` - Entire file disabled (intended)

## Next Steps

1. Remove commented module list in `snacks-full.lua:167-181` (safe - just examples)
2. Remove trace option in `debugging.lua:131` (safe - debug flag)
3. Keep `snacks.lua.disabled` as-is (intentionally preserved)

## Risks

- No functional risks - all identified code is truly dead
- Documentation value minimal - commented items are self-explanatory
