# Fish Shell Configuration

## Structure

This Fish configuration is organized for performance and maintainability:

### Configuration Files

- **config.fish** - Main configuration file with environment variables and core functions
- **conf.d/** - Modular configuration loaded automatically:
  - `00_path.fish` - Centralized PATH management
  - `00_environment.fish` - Environment variables
  - `aliases.fish` - All shell aliases
  - `git.fish` - Git abbreviations and aliases
  - `jj.fish` - Jujutsu abbreviations and aliases
  - `keybindings.fish` - Custom key bindings
  - `autopair.fish` - Auto-pairing brackets/quotes
  - `fzf.fish` - Fuzzy finder integration
  - `projects.fish` - Project navigation
  - `flexoki_dark_colors.fish` - Theme colors

### Functions

#### Core Functions
- **fish_prompt.fish** - Optimized prompt with git/jj status
- **fish_greeting.fish** - Custom greeting with system info
- **__fish_jj_prompt.fish** - Jujutsu VCS prompt integration
- **__fish_npm_scripts.fish** - NPM/PNPM script completion

#### Git Workflow Functions
- **git-branch-diff.fish** - Compare files vs branch (default: release)
- **git-hunks.fish** - Display all hunks with staging status
- **git-stage-interactive.fish** - Interactive staging with fzf
- **git-quick-commit.fish** - Quick commit with optional message
- **git-help.fish** - Comprehensive git command reference

#### Productivity Functions
- **projects.fish** - Quick project switcher with fzf
- **tm.fish** - Tmux session manager
- **nr.fish** - NPM script runner with fzf
- **killport.fish** - Kill process on specific port
- **gwe.fish** - Git worktree switcher
- **y** - Yazi file manager with directory change on exit

### Features

1. **Enhanced Git Workflow** - Custom functions for branch comparison, staging, and commits
2. **Lazy Loading** - rbenv, jenv, and thefuck load on first use
3. **Smart PATH** - Conditional path additions, no duplicates
4. **Git Integration** - Comprehensive abbreviations and worktree support
5. **Jujutsu (jj) Support** - Full prompt integration and abbreviations
6. **Package Manager** - npm/pnpm run completions
7. **Project Navigation** - Quick switching with fzf
8. **Interactive Tools** - FZF integration for git, npm, and project management

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

## Git Workflow

### Custom Git Functions

#### Compare with Branch
```bash
gbdiff        # Compare with release branch
gbdiff main   # Compare with main branch
```
Shows files with status indicators:
- ✓ Staged (green)
- ● Modified (yellow)
- ? Untracked (blue)
- ○ Branch diff (magenta)

#### View Hunks
```bash
ghunks  # Display all hunks with staging status
```

#### Interactive Staging
```bash
gsi  # Stage files interactively with fzf
```
Controls:
- `Ctrl-S` - Stage file
- `Ctrl-U` - Unstage file
- `Ctrl-D` - View diff
- `Ctrl-C` - View cached diff

#### Quick Commit
```bash
gqc                    # Prompts for message
gqc "Fix: auth issue"  # Direct commit with message
```

#### Git Help
```bash
ghelp  # or gh - Show all git commands
```

### Git Abbreviations

#### Basic Operations
```bash
g         # git
gst       # git status
gaa       # git add --all
gap       # git add -p (patch mode)
gc        # git commit
gcm       # git commit -m
gco       # git checkout
gcb       # git checkout -b
```

#### Diffs
```bash
gd        # git diff
gds       # git diff --staged
gdc       # git diff --cached
gdst      # git diff --stat
```

#### History
```bash
gl        # git log
glg       # git log --graph
glf       # git log --follow --
gbl       # git blame
```

#### Branches & Remote
```bash
gb        # git branch
gba       # git branch -a
gf        # git fetch
gpl       # git pull
gp        # git push
```

#### Reset & Stash
```bash
grh       # git reset HEAD
grhh      # git reset HEAD --hard
gs        # git stash
gsp       # git stash pop
```

## Project Navigation

### Quick Project Switcher
```bash
projects  # or press Ctrl-P
```
Searches in `~/projects/`, `~/work/`, `~/personal/`

### Tmux Session Manager
```bash
tm          # List/switch sessions
tm project  # Create/attach to session
```

### NPM Script Runner
```bash
nr  # Select and run npm scripts with fzf
```

## Keybindings

- `Ctrl-P` - Project switcher
- `Ctrl-G` - Lazygit
- `Ctrl-O` - Open in editor
- `Ctrl-E` - Edit command in editor
- `Ctrl-R` - History search (fzf)
- `Ctrl-F` - File search (fzf)
- `Alt-C` - Directory search (fzf)

## Utility Commands

### Kill Port
```bash
killport 3000  # Kill process on port 3000
```

### Enhanced ls (via eza)
```bash
ls   # eza with icons and git
ll   # long format with details
la   # show hidden files
lt   # tree view
```

### Directory Navigation
```bash
z project  # Jump to frecent directory
cd -       # Previous directory
..         # Parent directory
...        # Two levels up
```