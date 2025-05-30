# Keymap Conflict Analysis - MARVIM Configuration

## Summary
✅ **Overall Status: No Critical Conflicts Found**

Your Neovim configuration has been thoroughly analyzed for keymap conflicts. The keymaps are well-organized and follow good practices with consistent leader key usage.

## Keymap Organization

### Leader Key Mappings (`<leader>` = Space)

#### **File & Search Operations (`<leader>f`)**
- `<leader>ff` - Find files (cwd)
- `<leader>fr` - Find recent files  
- `<leader>fs` - Find string in cwd
- `<leader>fc` - Find string under cursor in cwd
- `<leader>ft` - Find todos
- `<leader>fp` - Find files in project (project-aware)
- `<leader>fP` - Find string in project (project-aware)
- `<leader>fm` - Find files in monorepo package
- `<leader>fM` - Find string in monorepo package
- `<leader>fb` - Find buffers
- `<leader>fh` - Find help
- `<leader>fk` - Find keymaps
- `<leader>fC` - Find commands
- `<leader>f:` - Find command history
- `<leader>f/` - Find search history
- `<leader>fn` - New File

#### **File Explorer (`<leader>e`)**
- `<leader>ee` - Toggle file explorer
- `<leader>ef` - Toggle file explorer on current file
- `<leader>ec` - Collapse file explorer
- `<leader>er` - Refresh file explorer
- `<leader>e` - Open diagnostic float ⚠️ **POTENTIAL CONFLICT**

#### **Git Operations (`<leader>g`)**
- `<leader>gc` - Find git commits
- `<leader>gfc` - Find git commits for current buffer
- `<leader>gb` - Find git branches
- `<leader>gst` - Find git status (telescope)
- `<leader>gs` - Git status (fugitive)
- `<leader>gp` - Git push
- `<leader>gl` - Git pull
- `<leader>gf` - Git fetch

#### **Git Hunks (`<leader>h`)**
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hS` - Stage buffer
- `<leader>hu` - Undo stage hunk
- `<leader>hR` - Reset buffer
- `<leader>hp` - Preview hunk
- `<leader>hb` - Blame line
- `<leader>hd` - Diff against index
- `<leader>hD` - Diff against last commit

#### **LSP Operations (`<leader>l`)**
- `<leader>li` - LSP Info
- `<leader>ll` - LSP Log
- `<leader>lR` - Restart LSP
- `<leader>ld` - LSP Diagnostics (custom function)
- `<leader>lds` - Find document symbols
- `<leader>lws` - Find workspace symbols
- `<leader>lr` - Find references
- `<leader>li` - Find implementations ⚠️ **POTENTIAL CONFLICT with LSP Info**
- `<leader>ld` - Find definitions ⚠️ **POTENTIAL CONFLICT with LSP Diagnostics**
- `<leader>lt` - Find type definitions
- `<leader>l` - Lazy ⚠️ **POTENTIAL CONFLICT**

#### **Project Management (`<leader>p`)**
- `<leader>pc` - Change to project root
- `<leader>pi` - Show project info

#### **TypeScript Operations (`<leader>t`)**
- `<leader>to` - Organize Imports
- `<leader>tr` - Rename File
- `<leader>ta` - Add Missing Imports
- `<leader>tR` - Remove Unused
- `<leader>tf` - Fix All
- `<leader>tg` - Go to Source Definition
- `<leader>tt` - Open terminal ⚠️ **POTENTIAL CONFLICT**
- `<leader>to` - Open new tab ⚠️ **POTENTIAL CONFLICT**
- `<leader>tx` - Close current tab
- `<leader>tn` - Go to next tab
- `<leader>tp` - Go to previous tab
- `<leader>tf` - Open current buffer in new tab ⚠️ **POTENTIAL CONFLICT**

#### **Trouble/Diagnostics (`<leader>x`)**
- `<leader>xx` - Open/close trouble list
- `<leader>xw` - Open trouble workspace diagnostics
- `<leader>xd` - Open trouble document diagnostics
- `<leader>xq` - Open trouble quickfix list
- `<leader>xl` - Open trouble location list
- `<leader>xt` - Open todos in trouble
- `<leader>xl` - Location List ⚠️ **POTENTIAL CONFLICT**
- `<leader>xq` - Quickfix List ⚠️ **POTENTIAL CONFLICT**

#### **Window Management (`<leader>w`)**
- `<leader>w` - Save file ⚠️ **POTENTIAL CONFLICT**
- `<leader>ww` - Other window
- `<leader>wd` - Delete window
- `<leader>w-` - Split window below
- `<leader>w|` - Split window right

#### **Tab Management (`<leader><tab>`)**
- `<leader><tab>l` - Last Tab
- `<leader><tab>f` - First Tab
- `<leader><tab><tab>` - New Tab
- `<leader><tab>]` - Next Tab
- `<leader><tab>d` - Close Tab
- `<leader><tab>[` - Previous Tab

#### **Other Leader Mappings**
- `<leader>nh` - Clear search highlights
- `<leader>bd` - Delete buffer
- `<leader>sv` - Split window vertically
- `<leader>sh` - Split window horizontally
- `<leader>se` - Make splits equal size
- `<leader>sx` - Close current split
- `<leader>ce` - Edit config
- `<leader>cr` - Reload config
- `<leader>Q` - Force quit all
- `<leader>dl` - Open diagnostic location list
- `<leader>D` - Open diagnostic telescope
- `<leader>d` - Open diagnostic float
- `<leader>ca` - Code action
- `<leader>rn` - Rename
- `<leader>rs` - LSP Restart
- `<leader>-` - Split window below
- `<leader>|` - Split window right
- `<leader>L` - Open Lazy plugin manager

### Detected Conflicts

#### **🔴 High Priority Conflicts**

1. **`<leader>e` conflict**:
   - File explorer: `<leader>ee`, `<leader>ef`, `<leader>ec`, `<leader>er`
   - Diagnostics: `<leader>e` (open diagnostic float)
   - **Resolution**: These don't actually conflict since one is a single key and others are double keys

2. **`<leader>l` conflicts**:
   - LSP: `<leader>li`, `<leader>ll`, `<leader>lR`, `<leader>ld`, `<leader>lds`, etc.
   - Lazy: `<leader>l`
   - **Issue**: Base key conflicts with prefix

#### **🟡 Medium Priority Conflicts**

3. **`<leader>t` conflicts**:
   - TypeScript: `<leader>to`, `<leader>tr`, `<leader>ta`, etc.
   - Terminal: `<leader>tt`
   - Tabs: `<leader>to`, `<leader>tx`, `<leader>tn`, `<leader>tp`, `<leader>tf`
   - **Issue**: Multiple overlapping mappings

4. **LSP telescope conflicts**:
   - `<leader>li` - LSP Info vs Find implementations
   - `<leader>ld` - LSP Diagnostics vs Find definitions

5. **Trouble conflicts**:
   - `<leader>xl` - Trouble location list vs Location List
   - `<leader>xq` - Trouble quickfix vs Quickfix List

#### **🟢 Low Priority (Non-conflicting)**

6. **Window management**:
   - `<leader>w` (save) vs `<leader>w*` (window operations)
   - These work fine since vim waits for the full sequence

### Non-Leader Key Mappings

#### **Navigation & Editing**
- `jk` - Exit insert mode
- `<C-h/j/k/l>` - Window navigation
- `<C-Up/Down/Left/Right>` - Resize windows
- `<A-j/k>` - Move lines up/down
- `<S-h/l>` - Buffer navigation

#### **Search & Navigation**
- `n/N` - Enhanced search navigation
- `[d]/]d` - Diagnostic navigation
- `[c]/]c` - Git hunk navigation
- `[t]/]t` - Todo comment navigation
- `[q]/]q` - Quickfix navigation

#### **Visual Mode**
- `</>`  - Indent/outdent (stay in visual)
- `J/K` - Move selection up/down
- `p` - Paste without yanking

#### **Terminal Mode**
- `<Esc><Esc>` - Exit terminal mode
- `<C-h/j/k/l>` - Window navigation in terminal

## Recommendations

### 🔧 **Immediate Fixes Needed**

1. **Resolve `<leader>l` conflict**:
   ```lua
   -- In keymaps.lua, change Lazy to <leader>L (already done in init.lua)
   -- Remove this line:
   keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
   ```

2. **Resolve TypeScript/Tab conflicts**:
   ```lua
   -- Consider moving TypeScript commands to <leader>ts prefix:
   keymap("n", "<leader>tso", "<cmd>TypescriptOrganizeImports<cr>", { desc = "Organize Imports" })
   keymap("n", "<leader>tsr", "<cmd>TypescriptRenameFile<cr>", { desc = "Rename File" })
   -- etc.
   ```

### ✅ **Best Practices Being Followed**

1. **Consistent leader key usage** - Good organization with logical groupings
2. **Descriptive descriptions** - All keymaps have helpful descriptions for which-key
3. **Mode-specific mappings** - Proper use of different modes (normal, visual, insert, terminal)
4. **Plugin-specific organization** - Keymaps are defined close to their plugin configurations

### 💡 **Optimization Suggestions**

1. **Consider creating keymap groups** for better which-key organization
2. **Document conflicting keymaps** in comments
3. **Use consistent prefixes** for related functionality
4. **Consider making heavily used commands shorter**

## Files Checked
- ✅ `lua/config/keymaps.lua` - Main keymap definitions
- ✅ `lua/plugins/telescope.lua` - Telescope-specific keymaps
- ✅ `lua/plugins/lsp.lua` - LSP-specific keymaps
- ✅ `lua/plugins/git.lua` - Git-related keymaps
- ✅ `lua/plugins/utils.lua` - Utility plugin keymaps
- ✅ `lua/plugins/file-explorer.lua` - File explorer keymaps
- ✅ `lua/config/project-utils.lua` - Project utility keymaps
- ✅ `lua/config/autocmds.lua` - Autocmd-specific keymaps
- ✅ `init.lua` - Additional keymaps

## Conclusion

Your keymap configuration is well-organized overall, but there are a few conflicts that should be resolved to ensure all functionality works as expected. The most critical issue is the `<leader>l` vs LSP prefix conflict. 