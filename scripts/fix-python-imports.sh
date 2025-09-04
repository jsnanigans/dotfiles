#!/usr/bin/env bash

PROJECT_DIR="${1:-$(pwd)}"

echo "Fixing Python imports in: $PROJECT_DIR"

cd "$PROJECT_DIR" || exit 1

if [ -d ".venv" ]; then
    echo "Found .venv directory"
    
    source .venv/bin/activate
    
    echo "Checking if pykalman is installed..."
    if ! python -c "import pykalman" 2>/dev/null; then
        echo "Installing pykalman..."
        pip install pykalman
    else
        echo "pykalman is already installed"
    fi
    
    echo "Python packages in virtual environment:"
    pip list | grep -E "(pykalman|numpy|scipy)"
    
    if [ ! -f "pyrightconfig.json" ]; then
        echo "Creating pyrightconfig.json..."
        cat > pyrightconfig.json << 'EOF'
{
  "include": ["**/*.py"],
  "exclude": ["**/node_modules", "**/__pycache__", "**/.*", "venv", ".venv"],
  "reportMissingImports": false,
  "reportMissingTypeStubs": false,
  "pythonVersion": "3.11",
  "venvPath": ".",
  "venv": ".venv"
}
EOF
    fi
    
    if [ ! -f ".ruff.toml" ]; then
        echo "Creating .ruff.toml to configure import sorting..."
        cat > .ruff.toml << 'EOF'
[lint]
ignore = ["I001"]

[lint.isort]
known-first-party = []
EOF
    fi
    
    echo ""
    echo "✅ Configuration complete!"
    echo ""
    echo "In Neovim, run:"
    echo "  :LspRestart"
    echo "  :PythonCheckEnv"
    echo ""
else
    echo "❌ No .venv directory found in $PROJECT_DIR"
    echo "Please create a virtual environment first:"
    echo "  python -m venv .venv"
    echo "  source .venv/bin/activate"
    echo "  pip install pykalman"
fi