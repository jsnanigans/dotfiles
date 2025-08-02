# Fish Shell Configuration

## Structure

This Fish configuration is organized for performance and maintainability:

### Configuration Files

- **config.fish** - Main configuration file with environment variables and core functions
- **conf.d/** - Modular configuration loaded automatically:
  - `00_path.fish` - Centralized PATH management
  - `aliases.fish` - All shell aliases
  - `git.fish` - Git abbreviations and aliases
  - `jj.fish` - Jujutsu abbreviations and aliases
  - `autopair.fish` - Auto-pairing brackets/quotes
  - `fzf.fish` - Fuzzy finder integration
  - `z.fish` - Directory jumping
  - `uv.env.fish` - UV environment

### Functions

- **fish_prompt.fish** - Optimized prompt with git/jj status
- **__fish_jj_prompt.fish** - Jujutsu VCS prompt integration
- **gwe.fish** - Git worktree switcher
- **__fish_npm_scripts.fish** - NPM/PNPM script completion
- **y** - Yazi file manager with directory change on exit

### Features

1. **Lazy Loading** - rbenv, jenv, and thefuck load on first use
2. **Smart PATH** - Conditional path additions, no duplicates
3. **Git Integration** - Comprehensive abbreviations and worktree support
4. **Jujutsu (jj) Support** - Full prompt integration and abbreviations
5. **Package Manager** - npm/pnpm run completions
6. **MemoryBank** - Full alias suite for knowledge management

### Installation

1. Install Fisher package manager:
   ```bash
   curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
   ```

2. Run the plugin installer:
   ```bash
   fish install_plugins.fish
   ```

### Key Optimizations

- **Performance**: Lazy loading of heavy tools, cached git prompt settings
- **Organization**: Modular conf.d structure for easy maintenance
- **Completions**: Smart completions for npm/pnpm scripts
- **PATH Management**: Centralized, conditional, no duplicates

### Prompt Format

The prompt shows:
- Current directory (shortened)
- VCS status (Git or Jujutsu):
  - **Git**: `(branch ↑2 ●3 ✚5)` - branch, ahead/behind, staged, modified
  - **Jujutsu**: `(abc123 main, feature ●)` - change ID, bookmarks, dirty indicator
- Exit status (if non-zero): `[1]`
- Prompt character: `$` (or `#` for root)