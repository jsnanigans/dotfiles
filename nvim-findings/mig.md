## Snacks.nvim Replacements (Already using snacks, could expand usage)

1. persistence.nvim → snacks.session (not yet in your config)
2. dressing.nvim → snacks.input (already enabled)
3. noice.nvim → snacks.notifier (already enabled)
4. lazygit.nvim → snacks.lazygit
5. flash.nvim → snacks.scope + snacks.jump (scope already enabled)
6. todo-comments.nvim → Could potentially use snacks picker with custom
patterns
7. which-key.nvim → snacks.toggle can handle some toggle mappings
8. dropbar.nvim → snacks.statuscolumn might offer similar breadcrumb
functionality

## Mini.nvim Replacements (Already using some mini modules)

1. nvim-autopairs → mini.pairs
2. ts-comments.nvim → mini.comment
3. gitsigns.nvim → mini.diff + mini.git
4. harpoon → mini.visits or mini.extra (for file navigation)
5. git-conflict.nvim → mini.git has conflict resolution features

## Already Optimized

You're already using:

• mini.ai (text objects)
• mini.surround (surround operations)
• mini.bufremove (buffer deletion)
• mini.icons (icons)
• mini.indentscope (indent visualization)

## Recommendation

The most impactful replacements would be:

1. Replace nvim-autopairs with mini.pairs for consistency
2. Replace ts-comments.nvim with mini.comment
3. Expand snacks.nvim usage for lazygit, session management
4. Consider replacing gitsigns.nvim with mini.diff + mini.git for a more
unified mini ecosystem
