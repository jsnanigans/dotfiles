# ============================================================================
# EDITOR
# ============================================================================
alias v nvim
alias v. "nvim ."
alias vi nvim
alias vim nvim

# ============================================================================
# FILESYSTEM
# ============================================================================
alias l "eza -l"
alias la "eza -la"
alias ll "eza -lh"
alias ls "eza"
alias cat "bat"
alias md mkdir
alias .. "cd .."
alias ... "cd ../.."

# ============================================================================
# PACKAGE MANAGERS & BUILD TOOLS
# ============================================================================
# npm/pnpm shortcuts
alias pn pnpm
alias nr "npm run"
alias pr "pnpm run"
alias ni "npm install"
alias pi "pnpm install"

# Common build commands
alias d "npm run dev"
alias b "npm run build"
alias t "npm run test"
alias dapp "pnpm run dev --filter=user-app --ui=stream"

# ============================================================================
# TMUX
# ============================================================================
alias t tm
alias ts tmux-search
alias tf tmux-filter
alias ta "tmux attach"
alias tl "tmux list-sessions"

# ============================================================================
# MEMORYBANK
# ============================================================================
alias mbcd "cd $MB_ROOT"
alias mbfind mb_find
alias mbsearch mb_search
alias mbtree mb_tree
alias mbstats mb_stats
alias mbnew mb_create
alias mblog mb_log_daily
alias mbguide mb_guide
alias mbticket mb_ticket
alias mbprojects mb_projects
alias mbrecent mb_recent
alias mbtags mb_analyze_tags
alias mbdaily mb_daily_show
alias mblogs mb_daily_list

# ============================================================================
# GIT
# ============================================================================
alias g git
alias gs "git status"
alias ga "git add"
alias gc "git commit"
alias gp "git push"
alias gl "git log --oneline --graph"
alias gd "git diff"
alias gco "git checkout"
alias gb "git branch"
