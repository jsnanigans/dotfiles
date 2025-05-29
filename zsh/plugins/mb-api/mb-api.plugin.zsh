# MemoryBank API Plugin for Zsh
# Provides CLI API functions for AI agents to interact with MemoryBank
# Installation: Copy to ~/.oh-my-zsh/custom/plugins/mb-api/ or source directly

# ============================================================================
# MARKDOWN HANDLING GUIDELINES
# ============================================================================

# 🚨 IMPORTANT: Handling Markdown Characters in Commands
# 
# When passing strings with markdown characters (#, *, [], (), etc.) to MB commands,
# ALWAYS wrap them in SINGLE QUOTES to prevent shell interpretation:
#
# ✅ CORRECT:
#   mb_log_daily 'Fixed issue #123 with [Auth] module'
#   mb_daily_entry 'Added PR #456 review' 'backend' 'review' '#backend #pr'
#   mb_dev_docs 'User auth system overhaul'
#
# ❌ WRONG (shell will interpret special characters):
#   mb_log_daily "Fixed issue #123 with [Auth] module"  # # becomes comment
#   mb_daily_entry "Added PR #456 review"               # # becomes comment
#
# 🔐 For strings with single quotes, use double quotes and escape:
#   mb_log_daily "User's authentication fix"
#   mb_log_daily "Fixed \"quoted\" string handling"
#
# 💡 PARAMETER GUIDELINES:
#   - description: Use single quotes for markdown safety
#   - project: Simple strings, usually safe
#   - type: Simple strings, usually safe  
#   - tags: Use single quotes, contains # characters
#   - details: Use single quotes for markdown safety

# ============================================================================
# CORE CONFIGURATION
# ============================================================================

# MemoryBank root path - adjust if needed
export MB_ROOT="${MB_ROOT:-/Users/brendanmullins/Documents/Obsidian/MCP/MCP/MemoryBank}"
export MB_TEMPLATES="$MB_ROOT/_System/templates"

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# Generate timestamp in MB format
mb_timestamp() {
    date '+%Y-%m-%dT%H-%M'
}

# Generate filename with proper MB naming convention
mb_format_filename() {
    local type="$1"
    local name="$2"
    local timestamp=$(mb_timestamp)
    
    # Sanitize name: remove special chars, truncate, clean up
    local clean_name=$(echo "$name" | \
        sed 's/[^a-zA-Z0-9 _-]//g' | \
        tr ' ' '-' | \
        tr '[:upper:]' '[:lower:]' | \
        sed 's/--*/-/g' | \
        sed 's/^-\|-$//g' | \
        cut -c1-50)
    
    # Ensure we have a valid name
    if [[ -z "$clean_name" ]]; then
        clean_name="untitled"
    fi
    
    echo "${type}_${timestamp}_${clean_name}.md"
}

# Get directory path for file type
mb_get_path() {
    local file_type="$1"
    case "$file_type" in
        "log")      echo "$MB_ROOT/Logs/development" ;;
        "analysis") echo "$MB_ROOT/Logs/analysis" ;;
        "daily")    echo "$MB_ROOT/Logs/daily" ;;
        "guide")    echo "$MB_ROOT/Knowledge/guides" ;;
        "dev-docs") echo "$MB_ROOT/Knowledge/guides" ;;
        "ticket")   echo "$MB_ROOT/Tickets/drafts" ;;
        "summary")  echo "$MB_ROOT/Intelligence/summaries" ;;
        *)          echo "$MB_ROOT" ;;
    esac
}

# ============================================================================
# SEARCH API
# ============================================================================

# Search content across MemoryBank
mb_search() {
    local query="$1"
    local context="${2:-3}"
    
    if [[ -z "$query" ]]; then
        echo "❌ Error: Search query required"
        echo "💡 Usage: mb_search \"query\" [context_lines]"
        return 1
    fi
    
    if [[ ! -d "$MB_ROOT" ]]; then
        echo "❌ Error: MemoryBank directory not found: $MB_ROOT"
        echo "💡 Check MB_ROOT environment variable"
        return 1
    fi
    
    if ! command -v rg &> /dev/null; then
        echo "❌ Error: ripgrep (rg) not installed"
        echo "💡 Install with: brew install ripgrep"
        return 1
    fi
    
    rg "$query" "$MB_ROOT" --type md -A "$context" -B "$context"
}

# Interactive file discovery with preview
mb_find() {
    local pattern="${1:-.*}"
    
    if [[ ! -d "$MB_ROOT" ]]; then
        echo "❌ Error: MemoryBank directory not found: $MB_ROOT"
        return 1
    fi
    
    if ! command -v fd &> /dev/null; then
        echo "❌ Error: fd not installed"
        echo "💡 Install with: brew install fd"
        return 1
    fi
    
    if ! command -v fzf &> /dev/null; then
        echo "❌ Error: fzf not installed"
        echo "💡 Install with: brew install fzf"
        return 1
    fi
    
    fd "$pattern" "$MB_ROOT" -t f | fzf --preview 'bat --color=always {}'
}

# Search by metadata (tags, status, etc.)
mb_search_meta() {
    local field="$1"
    local value="$2"
    rg "${field}:.*${value}" "$MB_ROOT" --type md
}

# Search by tags
mb_search_tags() {
    local tag="$1"
    rg "tags:.*${tag}" "$MB_ROOT" --type md -l
}

# Search by status
mb_search_status() {
    local status="$1"
    rg "status: ${status}" "$MB_ROOT" --type md -l
}

# Interactive search with edit capability
mb_search_edit() {
    local query="$1"
    local file=$(rg -l "$query" "$MB_ROOT" --type md | fzf --preview "rg --color=always -C 3 '$query' {}")
    [[ -n "$file" ]] && ${EDITOR:-code} "$file"
}

# ============================================================================
# READ API
# ============================================================================

# Read file with syntax highlighting
mb_read() {
    local file="$1"
    
    if [[ -z "$file" ]]; then
        echo "❌ Error: File path required"
        echo "💡 Usage: mb_read \"path/to/file.md\""
        return 1
    fi
    
    if [[ ! "$file" =~ ^$MB_ROOT ]]; then
        file="$MB_ROOT/$file"
    fi
    
    if [[ ! -f "$file" ]]; then
        echo "❌ Error: File not found: $file"
        echo "💡 Try: mb_find to search for files"
        return 1
    fi
    
    cat "$file"
}

# Read specific lines from file
mb_read_lines() {
    local file="$1"
    local start="$2"
    local end="$3"
    if [[ ! "$file" =~ ^$MB_ROOT ]]; then
        file="$MB_ROOT/$file"
    fi
    bat "$file" -r "${start}:${end}"
}

# Read frontmatter only
mb_read_meta() {
    local file="$1"
    if [[ ! "$file" =~ ^$MB_ROOT ]]; then
        file="$MB_ROOT/$file"
    fi
    head -20 "$file" | yq eval '.' -
}

# Show directory tree
mb_tree() {
    local dir="${1:-$MB_ROOT}"
    if [[ ! "$dir" =~ ^$MB_ROOT ]]; then
        dir="$MB_ROOT/$dir"
    fi
    tree "$dir" -I "*.DS_Store" --dirsfirst -L 2
}

# Get directory stats
mb_stats() {
    local dir="${1:-$MB_ROOT}"
    if [[ ! "$dir" =~ ^$MB_ROOT ]]; then
        dir="$MB_ROOT/$dir"
    fi
    echo "Markdown files in $(basename "$dir"): $(find "$dir" -name "*.md" | wc -l | tr -d ' ')"
}

# ============================================================================
# WRITE API
# ============================================================================

# Create new file with template and proper naming
mb_create() {
    local type="$1"
    local name="$2"
    local subdir="${3:-}"
    
    if [[ -z "$type" || -z "$name" ]]; then
        echo "❌ Error: Type and name required"
        echo "💡 Usage: mb_create \"type\" \"name\" [subdir]"
        echo "💡 Available types: log, guide, ticket, analysis"
        return 1
    fi
    
    if [[ ! -d "$MB_ROOT" ]]; then
        echo "❌ Error: MemoryBank directory not found: $MB_ROOT"
        return 1
    fi
    
    local filename=$(mb_format_filename "$type" "$name")
    local base_path=$(mb_get_path "$type")
    
    if [[ ! -d "$base_path" ]]; then
        echo "❌ Error: Base directory not found: $base_path"
        echo "💡 Try: mb_validate to check structure"
        return 1
    fi
    
    local full_path="$base_path"
    
    # Add subdirectory if specified
    if [[ -n "$subdir" ]]; then
        full_path="$base_path/$subdir"
    fi
    
    # Create directory if it doesn't exist
    if ! mkdir -p "$full_path"; then
        echo "❌ Error: Failed to create directory: $full_path"
        return 1
    fi
    
    local file_path="$full_path/$filename"
    local template_path="$MB_TEMPLATES/${type}_template.md"
    
    if [[ ! -f "$template_path" ]]; then
        echo "❌ Error: Template not found: $template_path"
        echo "💡 Available templates:"
        ls "$MB_TEMPLATES"/ 2>/dev/null || echo "  No templates directory found"
        return 1
    fi
    
    if ! cp "$template_path" "$file_path"; then
        echo "❌ Error: Failed to copy template"
        return 1
    fi
    
    # Replace placeholder timestamp with actual timestamp
    local timestamp=$(mb_timestamp)
    if command -v sed &> /dev/null; then
        sed -i '' "s/PLACEHOLDER_TIMESTAMP/$timestamp/g" "$file_path" 2>/dev/null
    fi
    
    echo "✅ Created: $file_path"
    echo "$file_path"
}

# Quick file creation with common types
mb_guide() { mb_create "guide" "$1" "${2:-}" ;}
mb_dev_docs() { mb_create "dev-docs" "$1" "${2:-}" ;}
mb_ticket() { mb_create "ticket" "$1" "${2:-}" ;}
mb_analysis() { mb_create "analysis" "$1" "${2:-}" ;}

# Update frontmatter field
mb_update_meta() {
    local file="$1"
    local key="$2"
    local value="$3"
    
    if [[ -z "$file" || -z "$key" || -z "$value" ]]; then
        echo "❌ Error: File, key, and value required"
        echo "💡 Usage: mb_update_meta \"file\" \"key\" \"value\""
        return 1
    fi
    
    if [[ ! "$file" =~ ^$MB_ROOT ]]; then
        file="$MB_ROOT/$file"
    fi
    
    if [[ ! -f "$file" ]]; then
        echo "❌ Error: File not found: $file"
        return 1
    fi
    
    if ! command -v yq &> /dev/null; then
        echo "❌ Error: yq not installed"
        echo "💡 Install with: brew install yq"
        return 1
    fi
    
    # Use yq's frontmatter mode to update only the YAML frontmatter section
    if ! yq eval --front-matter=process -i ".${key} = \"${value}\"" "$file" 2>/dev/null; then
        echo "❌ Error: Failed to update metadata in $file"
        return 1
    fi
    
    echo "✅ Updated $key in $(basename "$file")"
}

# Add tag to file
mb_add_tag() {
    local file="$1"
    local tag="$2"
    
    if [[ ! "$file" =~ ^$MB_ROOT ]]; then
        file="$MB_ROOT/$file"
    fi
    
    yq eval --front-matter=process -i ".tags += [\"${tag}\"]" "$file" 2>/dev/null
}

# Set file status
mb_set_status() {
    local file="$1"
    local status="$2"
    
    mb_update_meta "$file" "status" "$status"
    mb_update_meta "$file" "updated" "$(mb_timestamp)"
}

# ============================================================================
# LINK API
# ============================================================================

# Generate wiki link
mb_wiki_link() {
    local file_path="$1"
    local display_text="${2:-$(basename "$file_path" .md)}"
    echo "[[$file_path|$display_text]]"
}

# Find potential linking opportunities
mb_find_links() {
    local filename="$1"
    local keywords=$(basename "$filename" .md | tr '-_' ' ')
    rg -i "$keywords" "$MB_ROOT" --type md -l
}

# Check for broken links
mb_check_links() {
    local file="$1"
    if [[ ! "$file" =~ ^$MB_ROOT ]]; then
        file="$MB_ROOT/$file"
    fi
    
    rg '\[\[([^|\]]+)' -o --replace '$1' "$file" | while read -r link; do
        if [[ ! -f "$MB_ROOT/$link.md" ]]; then
            echo "Broken link: $link in $file"
        fi
    done
}

# ============================================================================
# PROJECT API
# ============================================================================

# List projects
mb_projects() {
    ls "$MB_ROOT/Projects/"
}

# Show project structure
mb_project() {
    local project="$1"
    if [[ -z "$project" ]]; then
        mb_projects
    else
        mb_tree "Projects/$project"
    fi
}

# Update project status
mb_project_status() {
    local project="$1"
    local status="$2"
    
    local readme="$MB_ROOT/Projects/$project/README.md"
    if [[ -f "$readme" ]]; then
        mb_set_status "$readme" "$status"
        echo "Updated $project status to $status"
    else
        echo "Project README not found: $readme"
        return 1
    fi
}

# Generate project summary
mb_project_summary() {
    local project="$1"
    local timestamp=$(mb_timestamp)
    local summary_file="$MB_ROOT/Intelligence/summaries/summary_${timestamp}_${project}.md"
    
    local file_count=$(find "$MB_ROOT/Projects/$project" -name "*.md" | wc -l | tr -d ' ')
    local last_update=$(find "$MB_ROOT/Projects/$project" -name "*.md" -exec stat -f "%m %N" {} + 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2- || echo "No recent updates")
    
    cat > "$summary_file" << EOF
# $project Summary - $timestamp

**Files**: $file_count  
**Last Update**: $last_update

## Quick Stats
- Total markdown files: $file_count
- Project path: Projects/$project
- Generated: $timestamp

## Recent Activity
$(find "$MB_ROOT/Projects/$project" -name "*.md" -mtime -7 | head -5 | sed 's|.*/||')
EOF
    
    echo "Created summary: $summary_file"
}

# ============================================================================
# INTELLIGENCE API
# ============================================================================

# Analyze tag usage across MemoryBank
mb_analyze_tags() {
    rg "tags: \[(.*)\]" "$MB_ROOT" --type md -o --replace '$1' | \
    tr ',' '\n' | \
    sed 's/[" #]//g' | \
    sort | uniq -c | sort -nr | head -20
}

# Get recent activity
mb_recent() {
    local days="${1:-7}"
    find "$MB_ROOT" -name "*.md" -mtime "-$days" -exec ls -la {} \; | head -10
}

# Update Intelligence summaries
mb_update_intelligence() {
    local timestamp=$(mb_timestamp)
    echo "Updating Intelligence summaries at $timestamp"
    
    # Update executive summary timestamp
    if [[ -f "$MB_ROOT/Intelligence/summaries/executive_summary_2025-05-23.md" ]]; then
        mb_update_meta "$MB_ROOT/Intelligence/summaries/executive_summary_2025-05-23.md" "updated" "$timestamp"
    fi
    
    echo "Intelligence summaries updated"
}

# ============================================================================
# MAINTENANCE API
# ============================================================================

# Daily maintenance routine
mb_maintenance() {
    echo "=== MemoryBank Daily Maintenance ==="
    echo
    
    # Check MemoryBank structure
    if [[ ! -d "$MB_ROOT" ]]; then
        echo "❌ Error: MemoryBank directory not found: $MB_ROOT"
        return 1
    fi
    
    echo "✅ MemoryBank Location: $MB_ROOT"
    echo
    
    echo "📊 File counts by directory:"
    for dir in "$MB_ROOT"/*; do
        if [[ -d "$dir" ]]; then
            local count=$(find "$dir" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
            echo "  $(basename "$dir"): $count files"
        fi
    done
    echo
    
    echo "🔗 Checking for files with wiki links (sample):"
    if command -v grep &> /dev/null; then
        find "$MB_ROOT" -name "*.md" -exec grep -l '\[\[.*\]\]' {} \; 2>/dev/null | head -5
    else
        echo "  grep not available"
    fi
    echo
    
    echo "📅 Recent files (last 24h):"
    find "$MB_ROOT" -name "*.md" -mtime -1 2>/dev/null | head -5 | while read file; do
        echo "  $(basename "$file")"
    done
    echo
    
    echo "🏷️ Top 10 tags:"
    if command -v rg &> /dev/null; then
        mb_analyze_tags | head -10
    else
        echo "  ripgrep not available for tag analysis"
    fi
    
    # Check for missing tools
    echo
    echo "🔧 Tool availability:"
    for tool in rg fd fzf bat tree jq yq; do
        if command -v "$tool" &> /dev/null; then
            echo "  ✅ $tool"
        else
            echo "  ❌ $tool (missing)"
        fi
    done
}

# Backup MemoryBank
mb_backup() {
    local backup_dir="${1:-$HOME/mb_backups}"
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_path="$backup_dir/mb_backup_$timestamp"
    
    mkdir -p "$backup_dir"
    cp -r "$MB_ROOT" "$backup_path"
    echo "Backup created: $backup_path"
}

# Validate MemoryBank structure
mb_validate() {
    echo "🔍 Validating MemoryBank structure..."
    
    # Check required directories
    local required_dirs=("_System" "Knowledge" "Projects" "Tickets" "Logs" "Intelligence" "Archive")
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$MB_ROOT/$dir" ]]; then
            echo "✅ $dir"
        else
            echo "❌ Missing: $dir"
        fi
    done
    
    # Check templates
    echo
    echo "📄 Templates:"
    for template in "$MB_TEMPLATES"/*.md; do
        if [[ -f "$template" ]]; then
            echo "✅ $(basename "$template")"
        fi
    done
}

# ============================================================================
# ALIASES AND SHORTCUTS
# ============================================================================

# Quick navigation
alias mbcd="cd $MB_ROOT"
alias mbfind="mb_find"
alias mbsearch="mb_search"
alias mbtree="mb_tree"
alias mbstats="mb_stats"

# Quick actions
alias mbnew="mb_create"
alias mblog="mb_log_daily"
alias mbguide="mb_guide"
alias mbticket="mb_ticket"

# Quick info
alias mbprojects="mb_projects"
alias mbrecent="mb_recent"
alias mbtags="mb_analyze_tags"

# ============================================================================
# INSTRUCTIONS AND HELP FUNCTIONS
# ============================================================================

# Display full AI agent instructions
mb_instructions() {
    local instructions_file="$MB_ROOT/_System/guidelines/ai_agent_instructions.md"
    if [[ -f "$instructions_file" ]]; then
        echo "📚 AI Agent Instructions - Complete Guide"
        echo "========================================="
        echo
        cat "$instructions_file"
    else
        echo "❌ Error: Instructions file not found at $instructions_file"
        echo "💡 Try: mb_validate to check MemoryBank structure"
        return 1
    fi
}

# Display quick API reference
mb_help() {
    cat << 'EOF'
🤖 MemoryBank API Commands

🚨 MARKDOWN SAFETY: Always use SINGLE QUOTES for strings with # * [] () etc.
   ✅ mb_log_daily 'Fixed issue #123'   ❌ mb_log_daily "Fixed issue #123"

📁 NAVIGATION & DISCOVERY:
  mb_find [pattern]         - Interactive file discovery
  mb_tree [dir]            - Show directory structure  
  mb_stats [dir]           - Get directory statistics
  mb_projects              - List all projects
  mb_project [name]        - Show project structure

🔍 SEARCH:
  mb_search <query> [ctx]  - Search content with context
  mb_search_tags <tag>     - Find files by tag
  mb_search_status <stat>  - Find files by status
  mb_search_meta <field>   - Search metadata fields
  mb_search_edit <query>   - Search and edit interactively
  mb_daily_search <query>  - Search daily logs

📖 READ:
  mb_read <file>           - Read file with highlighting
  mb_read_lines <file>     - Read specific line range
  mb_read_meta <file>      - Read frontmatter only
  mb_daily_show [date]     - Show daily log (default: today)

✍️  CREATE:
  mb_create <type> <name>  - Create file with template
  mb_guide <name>         - Create guide file  
  mb_dev_docs <name>      - Create dev documentation file
  mb_ticket <name>        - Create ticket file

📝 DAILY LOGGING:
  mb_log_daily <desc>      - Add entry to today's log (PREFERRED)
  mb_daily_entry <desc>    - Add timestamped entry (full params)
  mb_daily_init [date]     - Create/access daily log file
  mb_daily_list [days]     - List recent daily logs

🏷️  METADATA:
  mb_update_meta <file>    - Update frontmatter field
  mb_add_tag <file> <tag>  - Add tag to file
  mb_set_status <file>     - Set file status

🔗 LINKS:
  mb_wiki_link <path>      - Generate wiki link
  mb_find_links <file>     - Find linking opportunities
  mb_check_links <file>    - Check for broken links

📊 INTELLIGENCE:
  mb_analyze_tags          - Analyze tag usage
  mb_recent [days]         - Show recent activity
  mb_project_summary       - Generate project summary
  mb_update_intelligence   - Update Intelligence folder

🔧 MAINTENANCE:
  mb_maintenance           - Run daily maintenance
  mb_backup [dir]          - Backup MemoryBank
  mb_validate              - Validate structure

⚡ ALIASES:
  mbcd, mbfind, mbsearch, mbtree, mbstats
  mbnew, mblog (→mb_log_daily), mbguide, mbticket
  mbprojects, mbrecent, mbtags
  mbdaily, mblogs, mbsearch (daily logging)

📚 For detailed usage: mb_help | less
💡 For complete instructions: mb_instructions

🔄 EXAMPLE WORKFLOWS:
  # Daily logging with markdown safety
  mb_log_daily 'Fixed issue #123 with [Auth] module'
  mb_daily_entry 'PR review' 'backend' 'review' '#backend #pr'
  
  # Create feature documentation  
  mb_dev_docs 'user-authentication-overhaul'
  
  # Search and manage content
  mb_search 'authentication' 2
  mb_daily_search 'bug fix' 7
EOF
}

# ============================================================================
# PLUGIN INITIALIZATION
# ============================================================================

# Check if MemoryBank directory exists and validate setup
if [[ ! -d "$MB_ROOT" ]]; then
    echo "⚠️  MemoryBank not found at: $MB_ROOT"
    echo "   Set MB_ROOT environment variable to correct path"
    echo "💡 Try: export MB_ROOT=\"/path/to/your/MemoryBank\""
else
    # Check for required directories
    missing_dirs=()
    for dir in "_System" "Knowledge" "Projects" "Tickets" "Logs" "Intelligence" "Archive"; do
        if [[ ! -d "$MB_ROOT/$dir" ]]; then
            missing_dirs+=("$dir")
        fi
    done
    
    if [[ ${#missing_dirs[@]} -gt 0 ]]; then
        echo "⚠️  Missing MemoryBank directories: ${missing_dirs[*]}"
        echo "💡 Run: mb_validate for full structure check"
    fi
fi

# Check for required tools
missing_tools=()
for tool in rg fd fzf bat tree jq yq; do
    if ! command -v "$tool" &> /dev/null; then
        missing_tools+=("$tool")
    fi
done

if [[ ${#missing_tools[@]} -gt 0 ]]; then
    echo "⚠️  Missing required tools: ${missing_tools[*]}"
    echo "💡 Install with: brew install ${missing_tools[*]}"
fi

# ============================================================================
# DAILY LOGGING API
# ============================================================================

# Generate daily log filename for today
mb_daily_filename() {
    local date="${1:-$(date '+%Y-%m-%d')}"
    echo "$MB_ROOT/Logs/daily/${date}.md"
}

# Create or ensure daily log file exists for today
mb_daily_init() {
    local date="${1:-$(date '+%Y-%m-%d')}"
    local daily_file=$(mb_daily_filename "$date")
    local template_path="$MB_TEMPLATES/daily_log_template.md"
    
    # Create daily directory if it doesn't exist
    if ! mkdir -p "$MB_ROOT/Logs/daily"; then
        echo "❌ Error: Failed to create daily logs directory"
        return 1
    fi
    
    # If file doesn't exist, create it from template
    if [[ ! -f "$daily_file" ]]; then
        if [[ ! -f "$template_path" ]]; then
            echo "❌ Error: Daily log template not found: $template_path"
            return 1
        fi
        
        if ! cp "$template_path" "$daily_file"; then
            echo "❌ Error: Failed to create daily log file"
            return 1
        fi
        
        # Replace placeholders
        local timestamp=$(mb_timestamp)
        if command -v sed &> /dev/null; then
            sed -i '' "s/PLACEHOLDER_TIMESTAMP/$timestamp/g" "$daily_file" 2>/dev/null
            sed -i '' "s/PLACEHOLDER_DATE/$date/g" "$daily_file" 2>/dev/null
        fi
        
        echo "✅ Created daily log: $daily_file"
    fi
    
    echo "$daily_file"
}

# Add a timestamped entry to today's daily log
mb_daily_entry() {
    local description="$1"
    local project="${2:-}"
    local type="${3:-general}"
    local tags="${4:-}"
    local details="${5:-}"
    
    if [[ -z "$description" ]]; then
        echo "❌ Error: Description required"
        echo "💡 Usage: mb_daily_entry \"description\" [project] [type] [tags] [details]"
        return 1
    fi
    
    local daily_file=$(mb_daily_init)
    if [[ ! -f "$daily_file" ]]; then
        echo "❌ Error: Failed to create/access daily log file"
        return 1
    fi
    
    # Generate entry content
    local full_timestamp=$(date '+%H:%M:%S')
    local entry_content=""
    
    # Build entry header
    entry_content+="### 🕐 ${full_timestamp} - ${description}\n\n"
    
    # Add context if provided
    if [[ -n "$project" ]] || [[ -n "$type" ]] || [[ -n "$tags" ]]; then
        entry_content+="**Context**: "
        [[ -n "$type" ]] && entry_content+="Type: \`${type}\` "
        [[ -n "$project" ]] && entry_content+="| Project: \`${project}\` "
        [[ -n "$tags" ]] && entry_content+="| Tags: \`${tags}\`"
        entry_content+="\n\n"
    fi
    
    # Add details if provided
    if [[ -n "$details" ]]; then
        entry_content+="**Details**:\n${details}\n\n"
    fi
    
    entry_content+="---\n\n"
    
    # Find the insertion point (after "## 📝 Log Entries" header)
    local temp_file=$(mktemp)
    
    if awk '
        /^## 📝 Log Entries/ { 
            print $0; 
            print ""; 
            print "'"${entry_content}"'"; 
            next 
        }
        { print }
    ' "$daily_file" > "$temp_file"; then
        mv "$temp_file" "$daily_file"
    else
        rm -f "$temp_file"
        echo "❌ Error: Failed to add entry to daily log"
        return 1
    fi
    
    # Update metadata
    local current_timestamp=$(mb_timestamp)
    mb_update_meta "$daily_file" "updated" "$current_timestamp"
    
    # Note: Skipping entry count update to avoid frontmatter corruption
    # Entry count can be manually calculated if needed
    
    echo "✅ Added entry to daily log: $description"
    echo "📍 Log: $(basename "$daily_file")"
}

# Enhanced mb_log function that adds to daily log instead of creating individual files
mb_log_daily() {
    local description="$1"
    local project="${2:-}"
    local type="${3:-development}"
    local tags="${4:-#log}"
    local details="${5:-}"
    
    if [[ -z "$description" ]]; then
        echo "❌ Error: Description required"
        echo "💡 Usage: mb_log_daily \"description\" [project] [type] [tags] [details]"
        return 1
    fi
    
    # Validate description length (keep under 100 chars for readability)
    if [[ ${#description} -gt 100 ]]; then
        echo "⚠️  Warning: Description is quite long (${#description} chars)"
        echo "💡 Consider moving details to the 'details' parameter"
    fi
    
    mb_daily_entry "$description" "$project" "$type" "$tags" "$details"
}

# Show today's daily log
mb_daily_show() {
    local date="${1:-$(date '+%Y-%m-%d')}"
    local daily_file=$(mb_daily_filename "$date")
    
    if [[ ! -f "$daily_file" ]]; then
        echo "❌ No daily log found for $date"
        echo "💡 Create one with: mb_daily_init $date"
        return 1
    fi
    
    echo "📅 Daily Log: $date"
    echo "📍 File: $daily_file"
    echo
    
    if command -v bat &> /dev/null; then
        bat "$daily_file"
    else
        cat "$daily_file"
    fi
}

# List recent daily logs
mb_daily_list() {
    local days="${1:-7}"
    
    echo "📅 Recent Daily Logs (last $days days):"
    echo
    
    find "$MB_ROOT/Logs/daily" -name "*.md" -mtime "-$days" 2>/dev/null | \
    sort -r | \
    head -$days | \
    while read -r file; do
        local basename_file=$(basename "$file" .md)
        local entry_count=$(grep -c "^### 🕐" "$file" 2>/dev/null || echo "0")
        echo "  📄 $basename_file ($entry_count entries)"
    done
    
    if [[ ! -d "$MB_ROOT/Logs/daily" ]] || [[ -z "$(ls "$MB_ROOT/Logs/daily"/*.md 2>/dev/null)" ]]; then
        echo "  No daily logs found"
        echo "💡 Start logging with: mb_log_daily \"your first entry\""
    fi
}

# Search across daily logs
mb_daily_search() {
    local query="$1"
    local days="${2:-30}"
    
    if [[ -z "$query" ]]; then
        echo "❌ Error: Search query required"
        echo "💡 Usage: mb_daily_search \"query\" [days]"
        return 1
    fi
    
    echo "🔍 Searching daily logs for: '$query' (last $days days)"
    echo
    
    if command -v rg &> /dev/null; then
        find "$MB_ROOT/Logs/daily" -name "*.md" -mtime "-$days" 2>/dev/null | \
        xargs rg -i --color=always -C 2 "$query" 2>/dev/null || echo "No matches found"
    else
        find "$MB_ROOT/Logs/daily" -name "*.md" -mtime "-$days" 2>/dev/null | \
        xargs grep -i -C 2 "$query" 2>/dev/null || echo "No matches found"
    fi
}

# Quick aliases for daily logging
alias mbdaily="mb_daily_show"
alias mblogs="mb_daily_list"
alias mbsearch="mb_daily_search"