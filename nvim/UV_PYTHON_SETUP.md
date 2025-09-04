# UV Python Project Setup for Neovim

## Configuration Applied

1. **Switched from Pyright to Basedpyright** - Better UV support
2. **Auto-detection of `.venv` directories** - Automatically uses virtual environment
3. **UV-specific commands added**:
   - `:UvSync` - Sync UV dependencies
   - `:UvInstall <package>` - Install a package with UV

## For Your UV Projects

### Option 1: Automatic Setup (Recommended)
Just ensure your UV project has a `.venv` directory:
```bash
cd your-project
uv venv
uv sync
```

Neovim will automatically detect and use the virtual environment.

### Option 2: Add pyrightconfig.json
For more control, add a `pyrightconfig.json` to your project root:
```json
{
  "venvPath": ".",
  "venv": ".venv",
  "pythonVersion": "3.12",
  "include": ["src", "tests"],
  "exclude": ["**/__pycache__", ".venv"]
}
```

A template is available at: `~/dotfiles/nvim/marvim/templates/pyrightconfig.json`

## Troubleshooting

1. **If imports still not found**: 
   - Run `:LspRestart` in Neovim
   - Or run `:UvSync` to sync dependencies

2. **Check LSP is running**:
   - Run `:LspInfo` to verify basedpyright is attached

3. **Verify virtual environment**:
   - The status line should show when a UV project is detected
   - Check `:messages` for "UV project detected" notification

## Quick Test

1. Open a Python file in your UV project
2. You should see "UV project detected, using .venv" message
3. Imports should now resolve correctly

## Manual LSP Restart

If needed, you can always restart the LSP:
```vim
:LspRestart
```