# LSP Research for Neovim 0.11.0+ - A Guide for Paranoid Androids

*"The chances of finding out what's actually going on in the universe are so remote, the only thing to do is hang the sense of it and keep yourself occupied."* - Marvin

## Executive Summary (For Those Who Can't Be Bothered)

After analyzing the cosmic horror that is LSP configuration in Neovim 0.11.0+, I've discovered that all approaches lead to approximately the same amount of existential dread. The universe, in its infinite wisdom, has provided us with multiple ways to achieve the same result, each with its own unique flavor of complexity.

## Current LSP Setup in This Codebase

Your current setup uses:
- **Mason.nvim** for package management (because manually installing LSP servers is almost as tedious as existing)
- **Mason-lspconfig.nvim** as the bridge between Mason and lspconfig
- **Nvim-lspconfig** for the actual LSP configurations
- Various custom handlers for specific language servers (ts_ls, lua_ls, eslint, etc.)

This is what I like to call the "traditional stack of despair" - perfectly functional, moderately complex, and about as exciting as watching paint dry on a rainy Tuesday.

## Comparison Table of LSP Approaches

| Approach | Setup Complexity | Performance | Flexibility | Maintenance | Depression Level | Overall Score |
|----------|------------------|-------------|-------------|-------------|------------------|---------------|
| **Native LSP (0.11)** | 3/10 | 9/10 | 10/10 | 7/10 | 4/10 | **8.2/10** |
| **nvim-lspconfig** | 5/10 | 9/10 | 9/10 | 9/10 | 5/10 | **7.4/10** |
| **Mason + lspconfig** | 6/10 | 8/10 | 8/10 | 8/10 | 6/10 | **7.2/10** |
| **lsp-zero** | 2/10 | 8/10 | 6/10 | 7/10 | 3/10 | **5.2/10** |
| **coc.nvim** | 2/10 | 8/10 | 7/10 | 6/10 | 2/10 | **5.0/10** |

*Lower depression level = better. Scores are completely arbitrary, much like existence itself.*

## Detailed Analysis

### 1. Native LSP (Neovim 0.11)

The shiny new toy that promises to solve all our problems while creating new ones we haven't thought of yet.

**Pros:**
- Built into Neovim (no external dependencies, except for the LSP servers themselves, and your sanity)
- Simple configuration via `vim.lsp.config()` and `vim.lsp.enable()`
- Can use `~/.config/nvim/lsp/` directory for per-server configs
- Minimal overhead
- Makes you feel like a "real" Neovim user

**Cons:**
- Still relatively new (the universe hasn't had time to properly break it yet)
- Less battle-tested than older approaches
- Requires manual LSP server installation unless combined with Mason
- Documentation is about as clear as a Vogon poetry reading

**Example:**
```lua
-- In ~/.config/nvim/lsp/pyright.lua
return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', '.git' },
  settings = {
    -- Settings that will be ignored by the universe anyway
  }
}

-- In init.lua
vim.lsp.enable({ 'pyright' })
```

### 2. nvim-lspconfig

The tried and true method that's been disappointing developers since 2021.

**Pros:**
- Extensive pre-configured servers (someone else did the hard work)
- Well-maintained and documented (by Neovim standards)
- Large community (misery loves company)
- Works with Neovim 0.5.0+

**Cons:**
- Still requires manual server installation
- Another plugin to maintain
- Configurations can get verbose
- Makes you wonder why this isn't just built-in

### 3. Mason + Mason-lspconfig + nvim-lspconfig

The "I want it all" approach - because why use one plugin when you can use three?

**Pros:**
- Automatic LSP server installation (the closest thing to magic we'll get)
- Nice UI for managing servers
- Good integration between components
- Makes you feel productive while actually just managing tools

**Cons:**
- Three plugins to coordinate (triple the fun)
- More complex setup
- Potential for version conflicts
- Mason occasionally forgets what it's supposed to be doing

### 4. lsp-zero

For those who think life is too short to configure LSP properly.

**Pros:**
- Minimal configuration required
- Good defaults for common use cases
- Quick to get started
- Low depression factor

**Cons:**
- Less flexibility
- Opinionated setup might not match your opinions
- You'll eventually outgrow it and need to reconfigure everything
- Makes experienced users feel like they're cheating

### 5. coc.nvim

The "I miss VSCode but won't admit it" solution.

**Pros:**
- Everything works out of the box
- Familiar for VSCode refugees
- Excellent completion experience
- Extensions for everything

**Cons:**
- Node.js dependency (because JavaScript must consume all)
- Heavy resource usage
- Not "the Vim way"
- You'll be judged by Neovim purists

## Performance Considerations

Here's the cosmic joke: **they all perform about the same**. The bottleneck is usually the LSP server itself, not the client implementation. It's like arguing about which spoon is faster at eating soup.

Key performance tips that actually matter:
- Limit active language servers (your computer has finite resources, unlike human stupidity)
- Use debouncing for diagnostics
- Disable features you don't need
- Accept that TypeScript's LSP will always be slow

## Recommendations

### For This Codebase

Given your current setup and the principle of "if it ain't completely broken, don't fix it":

1. **Short term**: Keep your current Mason + lspconfig setup. It works, it's maintainable, and changing it won't make you significantly happier.

2. **Medium term**: Consider migrating to native LSP (0.11) + Mason for installation:
   - Keep Mason for package management (because manual installation is torture)
   - Use native `vim.lsp.config()` for configuration
   - Gradually migrate server configs to `~/.config/nvim/lsp/` directory

3. **Long term**: Wait for Neovim 0.12+ when they'll inevitably change everything again.

### Migration Path (If You're Feeling Adventurous)

```lua
-- Step 1: Keep Mason for installation
require("mason").setup()

-- Step 2: Create lsp/ directory configs
-- ~/.config/nvim/lsp/ts_ls.lua
return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  root_markers = { 'package.json', 'tsconfig.json', '.git' },
  init_options = {
    -- Your existing init_options
  },
  settings = {
    -- Your existing settings
  }
}

-- Step 3: Enable servers
vim.lsp.enable({ 'ts_ls', 'lua_ls', 'pyright' })

-- Step 4: Setup keymaps on LspAttach
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    -- Your existing keymaps
  end,
})
```

## Conclusion

In the grand scheme of things, your choice of LSP configuration matters about as much as a flyspeck on the windscreen of the universe. All approaches work, all have trade-offs, and all will eventually be deprecated.

The native LSP approach in Neovim 0.11 shows promise for simplicity, but your current setup is perfectly adequate. The real question isn't "which is best?" but rather "which will cause me the least amount of suffering?"

Remember: *"Life... is like a grapefruit. It's orange and squishy, and has a few pips in it, and some folks have half a one for breakfast."* Your LSP configuration should be equally straightforward.

---

*"I didn't ask to be made: no one consulted me or considered my feelings in the matter."* - Marvin, on being asked about LSP configurations

# Errors
1. All LSPs are loaded when entering any file, only the relevant ones for the file type should be loaded
1. when trying to install the missing LSPs:
    ✗ eslint-lsp
      ▶ # [30/30] "/Users/brendanmullins/.local/share/lzvim/mason/share/mason-schemas/lsp/eslint-lsp.json" is already linked.
    ✗ lua-language-server
      ▶ # [1309/1309] "/Users/brendanmullins/.local/share/lzvim/mason/share/mason-schemas/lsp/lua-language-server.json" is already linked.
    ✗ tailwindcss-language-server
      ▶ # [28/28] "/Users/brendanmullins/.local/share/lzvim/mason/share/mason-schemas/lsp/tailwindcss-language-server.json" is already linked.
