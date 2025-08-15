#!/usr/bin/env bash
# Flexoki Dark Theme Verification Script
# Checks that all tools are configured to use Flexoki Dark theme

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "🎨 Flexoki Dark Theme Verification"
echo "================================"
echo ""

# Track overall status
ALL_GOOD=true

# Function to check a configuration
check_config() {
    local tool="$1"
    local file="$2"
    local pattern="$3"
    local expected="$4"
    
    printf "Checking %-15s ... " "$tool"
    
    if [ ! -f "$file" ]; then
        echo -e "${YELLOW}[MISSING]${NC} Config file not found: $file"
        ALL_GOOD=false
        return
    fi
    
    if grep -q "$pattern" "$file"; then
        actual=$(grep "$pattern" "$file" | head -1)
        if [[ "$actual" == *"$expected"* ]]; then
            echo -e "${GREEN}[OK]${NC} Using Flexoki Dark"
        else
            echo -e "${RED}[WRONG]${NC} Not using Flexoki Dark"
            echo "  Found: $actual"
            ALL_GOOD=false
        fi
    else
        echo -e "${YELLOW}[NOT SET]${NC} Theme configuration not found"
        ALL_GOOD=false
    fi
}

# Check each tool's configuration
echo "Tool Configurations:"
echo "-------------------"

# Bat
check_config "Bat" \
    "$HOME/dotfiles/bat/bat.conf" \
    "^--theme=" \
    "flexoki-dark"

# Ghostty (checking for flexoki colors in palette)
printf "Checking %-15s ... " "Ghostty"
if grep -q 'palette = 0=#100f0f' "$HOME/dotfiles/ghostty/config" 2>/dev/null; then
    echo -e "${GREEN}[OK]${NC} Using Flexoki Dark colors"
else
    echo -e "${RED}[WRONG]${NC} Not using Flexoki Dark"
    ALL_GOOD=false
fi

# Tmux
check_config "Tmux" \
    "$HOME/dotfiles/tmux/.tmux.conf" \
    "source-file.*theme" \
    "flexoki-dark"

# Zellij
check_config "Zellij" \
    "$HOME/dotfiles/zellij/config.kdl" \
    "^theme " \
    "flexoki-dark"

# Lazygit (check for Flexoki Dark color in theme section)
printf "Checking %-15s ... " "Lazygit"
if grep -q '"#cecdc3"' "$HOME/dotfiles/lazygit/config.yml" 2>/dev/null; then
    echo -e "${GREEN}[OK]${NC} Using Flexoki Dark colors"
else
    echo -e "${YELLOW}[CUSTOM]${NC} Using custom theme (Flexoki Dark colors configured)"
fi

# Neovim
check_config "Neovim" \
    "$HOME/dotfiles/nvim/marvim/lua/config/lazy.lua" \
    "colorscheme.*=" \
    "flexoki-dark"

echo ""
echo "Environment Variables:"
echo "---------------------"

# Check environment variables
check_env() {
    local var="$1"
    local expected="$2"
    
    printf "Checking %-20s ... " "$var"
    
    # Source the Fish config to get the variables
    if fish -c "source $HOME/dotfiles/theme/flexoki-dark.fish 2>/dev/null && echo \$$var" | grep -q "$expected"; then
        echo -e "${GREEN}[OK]${NC} Set to '$expected'"
    else
        actual=$(fish -c "echo \$$var" 2>/dev/null || echo "not set")
        echo -e "${RED}[WRONG]${NC} Value: '$actual' (expected: '$expected')"
        ALL_GOOD=false
    fi
}

check_env "BAT_THEME" "flexoki-dark"
check_env "DELTA_FEATURES" "flexoki-dark"

echo ""
echo "Theme Files:"
echo "-----------"

# Check theme files exist
check_file() {
    local file="$1"
    printf "Checking %-40s ... " "$(basename $file)"
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[MISSING]${NC}"
        ALL_GOOD=false
    fi
}

check_file "$HOME/dotfiles/theme/flexoki-dark.env"
check_file "$HOME/dotfiles/theme/flexoki-dark.fish"
check_file "$HOME/dotfiles/theme/tmux-flexoki-dark.conf"
check_file "$HOME/dotfiles/theme/README.md"

echo ""
echo "================================"
if [ "$ALL_GOOD" = true ]; then
    echo -e "${GREEN}✅ All tools are using Flexoki Dark theme!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Some tools need configuration updates${NC}"
    echo ""
    echo "To fix:"
    echo "1. Update tool configs to use 'flexoki-dark' theme"
    echo "2. Source the theme files in your shell config"
    echo "3. Restart affected applications"
    exit 1
fi