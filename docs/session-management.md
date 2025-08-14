# Unified Session Management System

## Overview

The unified session management system provides a single, consistent interface for managing tmux sessions across your dotfiles. It consolidates previously fragmented session managers (tm function, tmux-sessionizer, tmux-launcher) into one cohesive system.

## Architecture

```
┌─────────────────────────────────────────┐
│         Unified Session Manager         │
│            (session.fish)               │
└────────────┬────────────────────────────┘
             │
    ┌────────┴────────┬──────────────┐
    ▼                 ▼              ▼
┌──────────┐  ┌──────────────┐  ┌────────────┐
│ Project  │  │    Session   │  │   Layout   │
│ Discovery│  │  Management  │  │   Save/    │
│          │  │              │  │  Restore   │
└──────────┘  └──────────────┘  └────────────┘
      │
┌─────┴──────────────────────┐
│   projects.fish            │
│  (Single source of truth)  │
└────────────────────────────┘
```

## Components

### 1. Project Discovery (`projects.fish`)

Single source of truth for project discovery and configuration.

**Configuration Variables:**
- `PROJECT_PATHS`: Directories to search for projects
- `PROJECT_MARKERS`: Files/directories that identify projects
- `SESSION_NAME_TRANSFORM`: How to sanitize project names for sessions

**Key Functions:**
- `discover_projects`: Find all projects based on markers
- `current_project`: Detect if currently in a project directory
- `project_info`: Get detailed information about a project
- `select_project`: Interactive project selection with fzf

### 2. Session Manager (`session.fish`)

Main interface for all session operations.

**Core Commands:**
```bash
session                 # List all sessions
session new [name]      # Create/switch to session
session project         # Project-based sessions
session switch          # Switch between sessions
session attach          # Attach to a session
session kill [name]     # Kill session(s)
```

**Advanced Commands:**
```bash
session rename          # Rename a session
session clone           # Clone current session
session save            # Save session layout
session restore         # Restore session layout
session clean           # Clean orphaned sessions
session info            # Show session details
```

### 3. Compatibility Wrappers

For smooth migration from old tools:

- **tm function**: Redirects to `session` command
- **tmux-launcher**: Uses unified system for session creation
- **tmux-sessionizer**: Wrapper script calling `session project`

## Usage Examples

### Basic Session Management

```bash
# List all sessions
session

# Create new session for current directory
session new

# Create named session
session new myproject

# Kill a session
session kill myproject

# Kill all sessions
session kill all
```

### Project-Based Sessions

```bash
# Open project selector
session project

# List all projects with session status
session project list

# Show current project info
session project current

# Sync session name with current project
session project sync
```

### Advanced Features

```bash
# Clone current session
session clone backup

# Save session layout
session save mysession

# Restore saved layout
session restore mysession

# Clean up orphaned sessions
session clean

# Get detailed session info
session info mysession
```

## Configuration

### Customizing Project Paths

Edit `fish/conf.d/projects.fish`:

```fish
set -gx PROJECT_PATHS \
    ~/work \
    ~/projects \
    ~/code \
    ~/Documents/GitHub
```

### Adding Project Markers

```fish
set -gx PROJECT_MARKERS \
    .git \
    package.json \
    Cargo.toml \
    requirements.txt \
    .projectile
```

### Session Naming Rules

```fish
# Transform project names for tmux compatibility
set -gx SESSION_NAME_TRANSFORM "tr . _ | tr - _ | tr ' ' _"
```

## Keybindings

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<prefix> f` | Project selector | Open project-based session selector |
| `<prefix> S` | Session filter | Filter and switch sessions with fzf |
| `<prefix> C` | New session | Create new session with prompt |
| `<prefix> BTab` | Last session | Switch to last session |

## Migration Guide

### From tm function

```bash
# Old way
tm new myproject
tm kill myproject
tm list

# New way
session new myproject
session kill myproject
session list
```

### From tmux-sessionizer

```bash
# Old way (bound to <prefix> f)
~/.local/bin/tmux-sessionizer

# New way (same keybinding works)
session project
```

### From custom scripts

Replace any custom session management with the unified API:

```fish
# In your scripts
source $DOTFILES/fish/conf.d/projects.fish
source $DOTFILES/fish/functions/session.fish

# Use the functions
set project (select_project "Choose project")
session new (project_name_from_path $project) $project
```

## Features

### Smart Project Detection

- Automatically detects project type (Node.js, Rust, Go, etc.)
- Creates sessions with project-specific names
- Maintains project-to-session mapping

### Session Persistence

- Save session layouts for later restoration
- Clone sessions for experimentation
- Automatic cleanup of orphaned sessions

### Interactive Selection

- FZF-powered project and session selection
- Preview windows showing session contents
- Multi-select for batch operations

### Status Indicators

- `●` Active/attached sessions
- `○` Detached sessions
- `📁` Sessions linked to projects

## Troubleshooting

### Session name conflicts

The system automatically sanitizes names using `SESSION_NAME_TRANSFORM`. If you have conflicts, check your transform rules.

### Projects not discovered

1. Verify project path is in `PROJECT_PATHS`
2. Check if project has required markers in `PROJECT_MARKERS`
3. Run `discover_projects` to debug

### Keybindings not working

```bash
# Reload tmux configuration
tmux source-file ~/.tmux.conf

# Verify keybinding is set
tmux list-keys | grep "session project"
```

## Best Practices

1. **Use project-based sessions**: Let the system manage session names based on projects
2. **Regular cleanup**: Run `session clean` periodically to remove orphaned sessions
3. **Save important layouts**: Use `session save` for complex window arrangements
4. **Leverage shortcuts**: Use the `s`, `sp`, `sn` aliases for quick access

## Integration Points

### With Neovim

The system respects vim-tmux-navigator for seamless pane switching.

### With AeroSpace

No conflicts - window management (AeroSpace) and session management (tmux) work on different levels.

### With Fish Shell

Deep integration with Fish functions and abbreviations for optimal workflow.

## Future Enhancements

- [ ] Session templates for project types
- [ ] Automatic session restoration on system restart
- [ ] Session sharing between machines
- [ ] Integration with version control status
- [ ] Smart window layout suggestions based on project type