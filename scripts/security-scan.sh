#!/bin/bash

# Security Scan Script for detecting accidentally committed secrets
# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Security Scan Started ===${NC}"
echo "Scanning for accidentally committed secrets, keys, and credentials..."
echo ""

# Create temporary file for results
RESULTS_FILE="/tmp/security_scan_results_$$.txt"
> "$RESULTS_FILE"

# Function to check if results were found
check_results() {
    if [ -s "$1" ]; then
        echo -e "${RED}[!] POTENTIAL SECRETS FOUND:${NC}"
        cat "$1"
        echo ""
    fi
}

echo -e "${YELLOW}[1] Checking for sensitive file names...${NC}"
find . -type f \( \
    -name "*.env*" -o \
    -name "*secret*" -o \
    -name "*key*" -o \
    -name "*token*" -o \
    -name "*password*" -o \
    -name "*credential*" -o \
    -name "*.pem" -o \
    -name "*.p12" -o \
    -name "*.pfx" \
\) 2>/dev/null | \
grep -v node_modules | \
grep -v ".git/" | \
grep -v ".png" | \
grep -v ".jpg" | \
grep -v ".jpeg" | \
grep -v ".gif" | \
grep -v ".svg" | \
grep -v ".ico" > /tmp/sensitive_files.txt

if [ -s /tmp/sensitive_files.txt ]; then
    echo -e "${YELLOW}Found files with sensitive naming patterns:${NC}"
    cat /tmp/sensitive_files.txt | head -20
    echo ""
fi

echo -e "${YELLOW}[2] Scanning for API keys and tokens...${NC}"
rg -i --no-heading \
    '(api[-_]?key|apikey|api[-_]?secret|secret[-_]?key|private[-_]?key|access[-_]?token|auth[-_]?token|bearer|oauth).*[:=]\s*["\x27][A-Za-z0-9+/=_\-]{20,}["\x27]' \
    --glob '!*.png' --glob '!*.jpg' --glob '!*.jpeg' --glob '!*.gif' --glob '!*.svg' \
    --glob '!node_modules/**' --glob '!.git/**' 2>/dev/null > /tmp/api_keys.txt

check_results /tmp/api_keys.txt

echo -e "${YELLOW}[3] Scanning for AWS credentials...${NC}"
rg -i --no-heading \
    '(aws_access_key_id|aws_secret_access_key|aws_session_token).*[:=]\s*["\x27][A-Za-z0-9+/=]{20,}["\x27]' \
    --glob '!node_modules/**' --glob '!.git/**' 2>/dev/null > /tmp/aws_creds.txt

check_results /tmp/aws_creds.txt

echo -e "${YELLOW}[4] Scanning for private keys...${NC}"
rg --no-heading \
    'BEGIN\s+(RSA|DSA|EC|OPENSSH|PGP|ENCRYPTED)?\s*(PRIVATE|SECRET)\s*KEY' \
    --glob '!node_modules/**' --glob '!.git/**' 2>/dev/null > /tmp/private_keys.txt

check_results /tmp/private_keys.txt

echo -e "${YELLOW}[5] Scanning for database connection strings...${NC}"
rg -i --no-heading \
    '(mongodb|postgres|postgresql|mysql|mariadb|redis|mssql|oracle)://[^:]+:[^@]+@' \
    --glob '!node_modules/**' --glob '!.git/**' 2>/dev/null > /tmp/db_connections.txt

check_results /tmp/db_connections.txt

echo -e "${YELLOW}[6] Scanning for hardcoded passwords...${NC}"
rg -i --no-heading \
    '(password|passwd|pwd|pass).*[:=]\s*["\x27][^\x27"]{8,}["\x27]' \
    --glob '!*.md' --glob '!*.txt' --glob '!node_modules/**' --glob '!.git/**' 2>/dev/null | \
    grep -v -i "example\|sample\|test\|dummy\|placeholder\|your[_-]password" > /tmp/passwords.txt

check_results /tmp/passwords.txt

echo -e "${YELLOW}[7] Scanning for GitHub tokens...${NC}"
rg --no-heading \
    '(ghp_[A-Za-z0-9]{36}|gho_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9]{22}_[A-Za-z0-9]{59})' \
    --glob '!node_modules/**' --glob '!.git/**' 2>/dev/null > /tmp/github_tokens.txt

check_results /tmp/github_tokens.txt

echo -e "${YELLOW}[8] Scanning for JWT tokens...${NC}"
rg --no-heading \
    'eyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+' \
    --glob '!node_modules/**' --glob '!.git/**' 2>/dev/null > /tmp/jwt_tokens.txt

check_results /tmp/jwt_tokens.txt

echo -e "${YELLOW}[9] Checking .env files...${NC}"
for env_file in $(find . -name "*.env*" -type f 2>/dev/null | grep -v node_modules | grep -v .git); do
    if [ -f "$env_file" ]; then
        echo -e "${YELLOW}Found .env file: $env_file${NC}"
        # Check if it contains actual values (not just placeholders)
        if grep -qE '=\s*["\x27]?[A-Za-z0-9+/=_\-]{10,}["\x27]?' "$env_file" 2>/dev/null; then
            echo -e "${RED}  Contains potential secrets!${NC}"
            grep -E '(KEY|TOKEN|SECRET|PASSWORD|CREDENTIAL)' "$env_file" 2>/dev/null | head -5
        fi
        echo ""
    fi
done

echo -e "${YELLOW}[10] Checking git history for removed secrets...${NC}"
# Only check recent commits to avoid long scan times
git log --diff-filter=D --pretty=format:'%h' -n 20 2>/dev/null | while read commit; do
    git diff-tree --no-commit-id --name-only -r "$commit" 2>/dev/null | \
    grep -E '\.(env|key|pem|p12|pfx)$' > /tmp/deleted_sensitive_files.txt
    
    if [ -s /tmp/deleted_sensitive_files.txt ]; then
        echo -e "${YELLOW}Commit $commit deleted potentially sensitive files:${NC}"
        cat /tmp/deleted_sensitive_files.txt
    fi
done

echo -e "${YELLOW}[11] Scanning for Slack tokens...${NC}"
rg --no-heading \
    '(xox[baprs]-[0-9]{10,12}-[0-9]{10,12}-[a-zA-Z0-9]{24,32})' \
    --glob '!node_modules/**' --glob '!.git/**' 2>/dev/null > /tmp/slack_tokens.txt

check_results /tmp/slack_tokens.txt

echo -e "${YELLOW}[12] Scanning for Google API keys...${NC}"
rg --no-heading \
    'AIza[A-Za-z0-9_-]{35}' \
    --glob '!node_modules/**' --glob '!.git/**' 2>/dev/null > /tmp/google_keys.txt

check_results /tmp/google_keys.txt

# Summary
echo -e "${GREEN}=== Security Scan Complete ===${NC}"
echo ""
echo "Summary of findings:"
echo "-------------------"

FOUND_ISSUES=false

for file in /tmp/api_keys.txt /tmp/aws_creds.txt /tmp/private_keys.txt /tmp/db_connections.txt /tmp/passwords.txt /tmp/github_tokens.txt /tmp/jwt_tokens.txt /tmp/slack_tokens.txt /tmp/google_keys.txt; do
    if [ -s "$file" ]; then
        FOUND_ISSUES=true
        break
    fi
done

if [ "$FOUND_ISSUES" = true ]; then
    echo -e "${RED}⚠️  SECURITY ISSUES DETECTED!${NC}"
    echo ""
    echo "Recommended actions:"
    echo "1. Remove any real secrets from the repository"
    echo "2. Rotate any exposed credentials immediately"
    echo "3. Use environment variables or secret management tools"
    echo "4. Add sensitive files to .gitignore"
    echo "5. Consider using git-secrets or similar pre-commit hooks"
    echo "6. If secrets were committed, consider rewriting git history"
else
    echo -e "${GREEN}✓ No obvious secrets detected${NC}"
    echo ""
    echo "Note: This scan covers common patterns but may not detect all secrets."
    echo "Always review your code carefully before committing."
fi

# Cleanup
rm -f /tmp/sensitive_files.txt /tmp/api_keys.txt /tmp/aws_creds.txt /tmp/private_keys.txt
rm -f /tmp/db_connections.txt /tmp/passwords.txt /tmp/github_tokens.txt /tmp/jwt_tokens.txt
rm -f /tmp/deleted_sensitive_files.txt /tmp/slack_tokens.txt /tmp/google_keys.txt