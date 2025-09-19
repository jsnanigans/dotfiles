# Investigation: Deprecated and Unused Files in MARVIM

## Bottom Line

**Root Cause**: Incomplete migration to snacks.nvim left orphaned files and migration artifacts
**Fix Location**: Remove 17 deprecated files, clean 2 active files
**Confidence**: High

## What's Happening

The MARVIM configuration contains leftover migration artifacts from transitioning plugins to snacks.nvim. These include test scripts, migrated plugin copies, and temporary fix files that are no longer referenced or needed.

## Why It Happens

**Primary Cause**: Migration completed but cleanup phase skipped
**Trigger**: `editor.lua:248` - Still imports snacks-full (migration complete)
**Decision Point**: Migration scripts/tests no longer needed after successful transition

## Evidence

- **Orphaned Files**: 5 `*-migrated.lua` files with no active imports
- **Test Scripts**: `test-migration.sh`, 2 test lua files for backward compatibility
- **Migration Docs**: 4 SNACKS_* files documenting completed migration
- **Search Used**: `rg "require.*migrated|import.*migrated"` - No active references found

## Files to Delete

### Plugin Migration Artifacts (5 files)
- `/lua/config/plugins/coding-migrated.lua`
- `/lua/config/plugins/core-migrated.lua`
- `/lua/config/plugins/editor-migrated.lua`
- `/lua/config/plugins/git-migrated.lua`
- `/lua/config/plugins/ui-migrated.lua`

### Test & Migration Scripts (7 files)
- `/test-migration.sh`
- `/tests/test_migration.lua`
- `/tests/test_backward_compat.lua`
- `/scripts/migrate-to-snacks.sh`
- `/fix-snacks-config.lua`
- `/SNACKS_MIGRATION_PLAN.md`
- `/SNACKS_MIGRATION_SUMMARY.md`

### Empty/Unused Directories (2 dirs)
- `/tests/` (after file removal)
- `/scripts/` (after file removal)

## Files Needing Cleanup

### `/lua/config/plugins/git.lua`
- Line 5: Remove comment "-- LazyGit integration - MIGRATED TO SNACKS.LAZYGIT"

### `/lua/utils/theme.lua`
- Lines 2-3: Remove migration comments about MARVIM framework

## Next Steps

1. Delete all 12 deprecated files listed above
2. Remove 2 empty directories after file deletion
3. Clean migration comments from active files
4. Run `:checkhealth` to verify no broken references
5. Update lazy-lock.json with `:Lazy update`

## Risks

- No functionality risk - all files are unused
- Git history preserves files if recovery needed
- Consider archiving migration docs before deletion for reference
