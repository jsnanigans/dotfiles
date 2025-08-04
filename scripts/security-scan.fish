#!/usr/bin/env fish

# Security scanner for detecting potential secrets and sensitive data
# Usage: security-scan.fish [directory] [--all]
# Options:
#   --all    Scan all files including git-ignored files (default: only scan tracked files)

set -l target_dir (pwd)
set -l scan_all false
set -l found_issues 0
set -l exclude_dirs ".git" "node_modules" ".env" "__pycache__" "venv" "vendor" "dist" "build"

# Parse arguments
for arg in $argv
    switch $arg
        case --all
            set scan_all true
        case '*'
            if test -d "$arg"
                set target_dir "$arg"
            end
    end
end

# Colors for output
set -l RED '\033[0;31m'
set -l YELLOW '\033[0;33m'
set -l GREEN '\033[0;32m'
set -l NC '\033[0m' # No Color

function print_header
    echo -e "$YELLOW""═══════════════════════════════════════════════════════════════$NC"
    echo -e "$YELLOW""   🔍 Security Scan - Checking for potential security leaks$NC"
    if test "$scan_all" = "true"
        echo -e "$YELLOW""   Mode: Scanning ALL files (including git-ignored)$NC"
    else
        echo -e "$YELLOW""   Mode: Scanning only git-tracked files$NC"
    end
    echo -e "$YELLOW""═══════════════════════════════════════════════════════════════$NC"
    echo ""
end

function print_issue
    set -l severity $argv[1]
    set -l file $argv[2]
    set -l line_num $argv[3]
    set -l pattern $argv[4]
    set -l content $argv[5]
    
    if test "$severity" = "HIGH"
        echo -e "$RED""[HIGH RISK]$NC $file:$line_num"
    else
        echo -e "$YELLOW""[MEDIUM RISK]$NC $file:$line_num"
    end
    echo "  Pattern: $pattern"
    echo "  Content: $content"
    echo ""
    
    set found_issues (math $found_issues + 1)
end

function scan_file
    set -l file $argv[1]
    
    # Skip binary files
    if file -b --mime-type "$file" | grep -q "text/"
        # High risk patterns
        set -l high_risk_patterns \
            'api[_-]?key\s*[:=]\s*["\']?[A-Za-z0-9_\-]{20,}' \
            'secret[_-]?key\s*[:=]\s*["\']?[A-Za-z0-9_\-]{20,}' \
            'access[_-]?token\s*[:=]\s*["\']?[A-Za-z0-9_\-]{20,}' \
            'auth[_-]?token\s*[:=]\s*["\']?[A-Za-z0-9_\-]{20,}' \
            'private[_-]?key\s*[:=]\s*["\']?[A-Za-z0-9_\-]{20,}' \
            'password\s*[:=]\s*["\'][^"\']{8,}' \
            'passwd\s*[:=]\s*["\'][^"\']{8,}' \
            'pwd\s*[:=]\s*["\'][^"\']{8,}' \
            'BEGIN RSA PRIVATE KEY' \
            'BEGIN DSA PRIVATE KEY' \
            'BEGIN EC PRIVATE KEY' \
            'BEGIN OPENSSH PRIVATE KEY' \
            'BEGIN PGP PRIVATE KEY' \
            'aws[_-]?access[_-]?key[_-]?id\s*[:=]\s*["\']?[A-Z0-9]{20}' \
            'aws[_-]?secret[_-]?access[_-]?key\s*[:=]\s*["\']?[A-Za-z0-9/+=]{40}' \
            'github[_-]?token\s*[:=]\s*["\']?gh[ps]_[A-Za-z0-9_]{36,}' \
            'gitlab[_-]?token\s*[:=]\s*["\']?glpat-[A-Za-z0-9_\-]{20,}' \
            'slack[_-]?token\s*[:=]\s*["\']?xox[baprs]-[A-Za-z0-9_\-]{10,}' \
            'stripe[_-]?key\s*[:=]\s*["\']?(sk|pk)_[a-z]+_[A-Za-z0-9]{24,}' \
            'mailgun[_-]?key\s*[:=]\s*["\']?key-[A-Za-z0-9]{32}' \
            'twilio[_-]?(auth[_-]?)?token\s*[:=]\s*["\']?[A-Za-z0-9]{32}' \
            'sendgrid[_-]?key\s*[:=]\s*["\']?SG\.[A-Za-z0-9_\-]{22}\.[A-Za-z0-9_\-]{43}'
        
        # Medium risk patterns
        set -l medium_risk_patterns \
            'token\s*[:=]\s*["\']?[A-Za-z0-9_\-]{16,}' \
            'key\s*[:=]\s*["\']?[A-Za-z0-9_\-]{16,}' \
            'secret\s*[:=]\s*["\']?[A-Za-z0-9_\-]{16,}' \
            'client[_-]?id\s*[:=]\s*["\']?[A-Za-z0-9_\-]{20,}' \
            'client[_-]?secret\s*[:=]\s*["\']?[A-Za-z0-9_\-]{20,}' \
            'database[_-]?url\s*[:=]\s*["\']?[^"\']+@[^"\']+' \
            'db[_-]?connection\s*[:=]\s*["\']?[^"\']+@[^"\']+' \
            'mongodb://[^:]+:[^@]+@[^/]+' \
            'postgres://[^:]+:[^@]+@[^/]+' \
            'mysql://[^:]+:[^@]+@[^/]+' \
            'ftp://[^:]+:[^@]+@[^/]+' \
            'ssh://[^:]+:[^@]+@[^/]+' \
            'smtp://[^:]+:[^@]+@[^/]+' \
            '.+@.+\..+:.+' \
            'credential[s]?\s*[:=]\s*["\'][^"\']+' \
            'auth\s*[:=]\s*["\'][^"\']+' \
            'x-api-key:\s*["\']?[A-Za-z0-9_\-]{16,}' \
            'authorization:\s*bearer\s+[A-Za-z0-9_\-\.]+' \
            'basic\s+[A-Za-z0-9+/]+=*'
        
        # Check high risk patterns
        for pattern in $high_risk_patterns
            set -l matches (grep -inE "$pattern" "$file" 2>/dev/null)
            for match in $matches
                set -l line_num (echo $match | cut -d: -f1)
                set -l content (echo $match | cut -d: -f2- | head -c 100)
                # Skip if this is the security scan script defining patterns
                if not string match -q "*/security-scan.fish" -- "$file"
                    print_issue "HIGH" "$file" "$line_num" "$pattern" "$content"
                else if not string match -q -r "^[[:space:]]*'" -- "$content"
                    print_issue "HIGH" "$file" "$line_num" "$pattern" "$content"
                end
            end
        end
        
        # Check medium risk patterns
        for pattern in $medium_risk_patterns
            set -l matches (grep -inE "$pattern" "$file" 2>/dev/null)
            for match in $matches
                set -l line_num (echo $match | cut -d: -f1)
                set -l content (echo $match | cut -d: -f2- | head -c 100)
                # Skip if it's a common false positive or the security scan script itself
                set -l lower_content (echo "$content" | tr '[:upper:]' '[:lower:]')
                if not string match -q -r 'example|test|demo|fake|dummy|placeholder|todo|fixme' -- "$lower_content"
                    # Skip if this is the security scan script defining patterns
                    if not string match -q "*/security-scan.fish" -- "$file"
                        print_issue "MEDIUM" "$file" "$line_num" "$pattern" "$content"
                    else if not string match -q -r "^[[:space:]]*'" -- "$content"
                        print_issue "MEDIUM" "$file" "$line_num" "$pattern" "$content"
                    end
                end
            end
        end
    end
end

function check_sensitive_files
    # Check for sensitive file types
    set -l sensitive_files \
        "*.pem" "*.key" "*.p12" "*.pfx" "*.jks" "*.keystore" \
        "*.env" ".env.*" "*.config" "*.conf" \
        "*credentials*" "*secret*" "*token*" \
        "id_rsa" "id_dsa" "id_ecdsa" "id_ed25519" \
        ".aws/credentials" ".aws/config" \
        ".ssh/config" ".ssh/known_hosts" \
        ".netrc" ".pgpass" ".my.cnf" \
        "wp-config.php" "config.php" "settings.py" \
        ".htpasswd" ".gitconfig" ".npmrc" \
        "*.sql" "*.db" "*.sqlite"
    
    for pattern in $sensitive_files
        set -l files
        if test "$scan_all" = "true"
            set files (find "$target_dir" -type f -name "$pattern" 2>/dev/null | grep -vE (string join '|' $exclude_dirs))
        else
            # Only check git-tracked files
            if test -d "$target_dir/.git"
                set -l old_pwd (pwd)
                cd "$target_dir"
                set files (git ls-files "$pattern" 2>/dev/null | sed "s|^|$target_dir/|")
                cd "$old_pwd"
            end
        end
        
        for file in $files
            if test -f "$file"
                echo -e "$YELLOW""[WARNING]$NC Sensitive file found: $file"
                set found_issues (math $found_issues + 1)
            end
        end
    end
end

function check_git_history
    if test -d "$target_dir/.git"
        echo -e "$YELLOW""Checking git history for removed secrets...$NC"
        
        # Check recently deleted files for sensitive names
        set -l deleted_files (cd "$target_dir" && git log --diff-filter=D --summary --since="6 months ago" 2>/dev/null | grep "delete mode" | awk '{print $4}')
        for file in $deleted_files
            if string match -q -r '(secret|token|key|credential|password|\.env|config)' "$file"
                echo -e "$YELLOW""[WARNING]$NC Recently deleted sensitive file: $file"
                echo "  Consider using 'git filter-branch' or 'BFG Repo-Cleaner' to remove from history"
                set found_issues (math $found_issues + 1)
            end
        end
    end
end

function generate_gitignore_suggestions
    set -l missing_ignores
    
    # Check if common sensitive files exist but aren't in .gitignore
    set -l should_ignore ".env" ".env.local" ".env.*.local" "*.pem" "*.key" \
        "*.p12" "*.pfx" ".DS_Store" "*.log" "credentials.json" \
        "config.json" "secrets.json" "*.sqlite" "*.db"
    
    if test -f "$target_dir/.gitignore"
        for pattern in $should_ignore
            if find "$target_dir" -name "$pattern" -type f 2>/dev/null | head -n1 | read -l found_file
                if not grep -q "$pattern" "$target_dir/.gitignore"
                    set missing_ignores $missing_ignores "$pattern"
                end
            end
        end
    end
    
    if test (count $missing_ignores) -gt 0
        echo -e "$YELLOW""Consider adding these patterns to .gitignore:$NC"
        for pattern in $missing_ignores
            echo "  $pattern"
        end
        echo ""
    end
end

# Main execution
print_header

echo "Scanning directory: $target_dir"
echo ""

# Get list of files to scan
set -l files_to_scan
set -l total_files 0

if test "$scan_all" = "true"
    # Build find command with exclusions for all files
    set -l find_cmd "find '$target_dir' -type f"
    for dir in $exclude_dirs
        set find_cmd "$find_cmd -not -path '*/$dir/*'"
    end
    set files_to_scan (eval $find_cmd 2>/dev/null)
else
    # Only scan git-tracked files
    if test -d "$target_dir/.git"
        set -l old_pwd (pwd)
        cd "$target_dir"
        # Get all tracked files (not ignored by git)
        set files_to_scan (git ls-files 2>/dev/null | sed "s|^|$target_dir/|")
        cd "$old_pwd"
    else
        echo -e "$RED""Error: Not a git repository. Use --all flag to scan all files.$NC"
        exit 1
    end
end

# Scan files
for file in $files_to_scan
    if test -f "$file"
        scan_file "$file"
        set total_files (math $total_files + 1)
    end
end

# Check for sensitive file types
check_sensitive_files

# Check git history
check_git_history

# Generate .gitignore suggestions
generate_gitignore_suggestions

# Summary
echo -e "$YELLOW""═══════════════════════════════════════════════════════════════$NC"
if test $found_issues -eq 0
    echo -e "$GREEN""✅ Security scan complete! No issues found.$NC"
else
    echo -e "$RED""⚠️  Security scan complete! Found $found_issues potential issues.$NC"
    echo ""
    echo "Recommendations:"
    echo "  1. Review each finding and determine if it's a real security risk"
    echo "  2. Move secrets to environment variables or secure vaults"
    echo "  3. Update .gitignore to exclude sensitive files"
    echo "  4. Consider using git-secrets or similar pre-commit hooks"
    echo "  5. Rotate any exposed credentials immediately"
end
echo -e "$YELLOW""═══════════════════════════════════════════════════════════════$NC"
echo "Total files scanned: $total_files"
if test "$scan_all" = "false"
    echo "Note: Only scanned git-tracked files. Use --all to scan all files."
end

exit $found_issues