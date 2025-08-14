#!/bin/bash
# Test script for Phase 1 migrations (session and lazygit)

echo "=== Testing Snacks.nvim Phase 1 Migration ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track results
TESTS_PASSED=0
TESTS_FAILED=0

echo "1. Checking plugin installation status..."
echo "----------------------------------------"

# Check lazy-lock.json for plugin status
if grep -q '"snacks.nvim"' ~/dotfiles/nvim/marvim/lazy-lock.json; then
    echo -e "${GREEN}✓${NC} snacks.nvim is installed"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} snacks.nvim is not installed"
    ((TESTS_FAILED++))
fi

if grep -q '"persistence.nvim"' ~/dotfiles/nvim/marvim/lazy-lock.json; then
    echo -e "${YELLOW}⚠${NC} persistence.nvim is still in lazy-lock.json (should be removed after nvim restart)"
else
    echo -e "${GREEN}✓${NC} persistence.nvim has been removed"
    ((TESTS_PASSED++))
fi

if grep -q '"lazygit.nvim"' ~/dotfiles/nvim/marvim/lazy-lock.json; then
    echo -e "${YELLOW}⚠${NC} lazygit.nvim is still in lazy-lock.json (should be removed after nvim restart)"
else
    echo -e "${GREEN}✓${NC} lazygit.nvim has been removed"
    ((TESTS_PASSED++))
fi

echo ""
echo "2. Testing Neovim configuration..."
echo "-----------------------------------"

# Test if nvim starts without errors
if nvim --headless -c ':checkhealth' -c ':qall' 2>&1 | grep -q 'ERROR'; then
    echo -e "${RED}✗${NC} Neovim has errors during startup"
    ((TESTS_FAILED++))
else
    echo -e "${GREEN}✓${NC} Neovim starts without errors"
    ((TESTS_PASSED++))
fi

# Test keymappings exist
echo ""
echo "3. Testing keybindings..."
echo "-------------------------"

# Create a test vim script to check keymaps
cat > /tmp/test_keymaps.vim << 'EOF'
let g:test_results = []

" Test session keymaps
if !empty(maparg('<leader>qs', 'n'))
    call add(g:test_results, 'session_load: PASS')
else
    call add(g:test_results, 'session_load: FAIL')
endif

if !empty(maparg('<leader>ql', 'n'))
    call add(g:test_results, 'session_last: PASS')
else
    call add(g:test_results, 'session_last: FAIL')
endif

if !empty(maparg('<leader>qd', 'n'))
    call add(g:test_results, 'session_stop: PASS')
else
    call add(g:test_results, 'session_stop: FAIL')
endif

" Test lazygit keymap
if !empty(maparg('<leader>gg', 'n'))
    call add(g:test_results, 'lazygit: PASS')
else
    call add(g:test_results, 'lazygit: FAIL')
endif

if !empty(maparg('<leader>gf', 'n'))
    call add(g:test_results, 'lazygit_file: PASS')
else
    call add(g:test_results, 'lazygit_file: FAIL')
endif

" Output results
for result in g:test_results
    echo result
endfor

quit
EOF

# Run the test
KEYMAP_RESULTS=$(nvim --headless -u ~/dotfiles/nvim/marvim/init.lua -S /tmp/test_keymaps.vim 2>&1)

if echo "$KEYMAP_RESULTS" | grep -q "session_load: PASS"; then
    echo -e "${GREEN}✓${NC} <leader>qs keymap exists (session load)"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} <leader>qs keymap missing"
    ((TESTS_FAILED++))
fi

if echo "$KEYMAP_RESULTS" | grep -q "session_last: PASS"; then
    echo -e "${GREEN}✓${NC} <leader>ql keymap exists (last session)"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} <leader>ql keymap missing"
    ((TESTS_FAILED++))
fi

if echo "$KEYMAP_RESULTS" | grep -q "session_stop: PASS"; then
    echo -e "${GREEN}✓${NC} <leader>qd keymap exists (stop session)"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} <leader>qd keymap missing"
    ((TESTS_FAILED++))
fi

if echo "$KEYMAP_RESULTS" | grep -q "lazygit: PASS"; then
    echo -e "${GREEN}✓${NC} <leader>gg keymap exists (lazygit)"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} <leader>gg keymap missing"
    ((TESTS_FAILED++))
fi

if echo "$KEYMAP_RESULTS" | grep -q "lazygit_file: PASS"; then
    echo -e "${GREEN}✓${NC} <leader>gf keymap exists (lazygit file)"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} <leader>gf keymap missing"
    ((TESTS_FAILED++))
fi

# Clean up
rm -f /tmp/test_keymaps.vim

echo ""
echo "4. Configuration file checks..."
echo "-------------------------------"

# Check if old plugins are commented out
if grep -q "^[[:space:]]*--.*persistence\.nvim" ~/dotfiles/nvim/marvim/lua/config/plugins/core.lua; then
    echo -e "${GREEN}✓${NC} persistence.nvim is commented out"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} persistence.nvim is not properly commented"
    ((TESTS_FAILED++))
fi

if grep -q "^[[:space:]]*--.*lazygit\.nvim" ~/dotfiles/nvim/marvim/lua/config/plugins/git.lua; then
    echo -e "${GREEN}✓${NC} lazygit.nvim is commented out"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} lazygit.nvim is not properly commented"
    ((TESTS_FAILED++))
fi

# Check if snacks-full is imported
if grep -q 'import.*"config.plugins.editor.snacks-full"' ~/dotfiles/nvim/marvim/lua/config/plugins/editor.lua; then
    echo -e "${GREEN}✓${NC} snacks-full.lua is imported"
    ((TESTS_PASSED++))
else
    echo -e "${RED}✗${NC} snacks-full.lua is not imported"
    ((TESTS_FAILED++))
fi

echo ""
echo "========================================"
echo "Test Results Summary:"
echo "----------------------------------------"
echo -e "${GREEN}Passed:${NC} $TESTS_PASSED"
echo -e "${RED}Failed:${NC} $TESTS_FAILED"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed! Migration successful.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Restart Neovim to apply all changes"
    echo "2. Run :Lazy update to clean up unused plugins"
    echo "3. Test session management with <leader>qs and <leader>qS"
    echo "4. Test lazygit with <leader>gg"
    exit 0
else
    echo -e "${RED}✗ Some tests failed. Please review the migration.${NC}"
    echo ""
    echo "Troubleshooting:"
    echo "1. Make sure you've restarted Neovim"
    echo "2. Check :Lazy for any plugin errors"
    echo "3. Run :checkhealth to diagnose issues"
    exit 1
fi