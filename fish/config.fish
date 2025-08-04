# Fish Shell Configuration

# ============================================================================
# CORE ENVIRONMENT
# ============================================================================

# Dotfiles directory (used by other configs)
set -gx DOTFILES $HOME/dotfiles

# Editor configuration
if test -n "$SSH_CONNECTION"
    set -gx EDITOR vim
else
    set -gx EDITOR nvim
end
set -gx NVIM_APPNAME marvim

# ============================================================================
# DEVELOPMENT TOOLS
# ============================================================================

# Package managers
set -gx BUN_INSTALL $HOME/.bun
set -gx N_PREFIX $HOME/n
set -gx PNPM_HOME $HOME/Library/pnpm

# Mobile development
set -gx ANDROID_HOME /Users/brendanmullins/Library/Android/sdk
set -gx IOS_API_FILE_PATH /Users/brendanmullins/app_cert/old/AuthKey_TT439J2PCV.p8
set -gx IOS_API_KEY_ID TT439J2PCV

# ============================================================================
# APPLICATION CONFIGS
# ============================================================================

# Bat (better cat)
set -gx BAT_CONFIG_PATH $DOTFILES/bat/bat.conf

# MemoryBank
set -gx MB_ROOT /Users/brendanmullins/Documents/Obsidian/MCP/MCP/MemoryBank
set -gx MB_TEMPLATES $MB_ROOT/_System/templates

# API Keys (empty by default)
set -gx GEMINI_API_KEY ""

# ============================================================================
# PATH CONFIGURATION
# ============================================================================
# PATH is managed in conf.d/00_path.fish for early loading

# ============================================================================
# INTERACTIVE CONFIGURATION
# ============================================================================

if status is-interactive
    # Load .env.sh if exists
    if test -f "$DOTFILES/.env.sh"
        # Bass is needed to source bash scripts in fish
        # Install with: fisher install edc/bass
        if command -q bass
            bass source "$DOTFILES/.env.sh"
        end
    end

    # Initialize tools (lazy loading for better performance)
    # Ruby environment - load only when needed
    function rbenv --wraps rbenv
        functions -e rbenv
        if command -q rbenv
            rbenv init - | source
            rbenv $argv
        end
    end

    # Java environment - load only when needed
    function jenv --wraps jenv
        functions -e jenv
        if command -q jenv
            jenv init - | source
            jenv $argv
        end
    end

    # The fuck - load on first use
    function fuck --wraps thefuck
        functions -e fuck
        if command -q thefuck
            thefuck --alias | source
            fuck $argv
        end
    end

    # ============================================================================
    # INTERACTIVE SHORTCUTS
    # ============================================================================
    # Most aliases are in conf.d/aliases.fish
    # This one stays here due to lazy loading dependency
    alias f fuck

    # ============================================================================
    # FUNCTIONS
    # ============================================================================

    # Yazi file manager with cd on exit
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
            cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end


    # ============================================================================
    # FISH FEATURES
    # ============================================================================
    # Enable autosuggestions
    set -g fish_autosuggestion_enabled 1
    
    # ============================================================================
    # TMUX INTEGRATION
    # ============================================================================
    # Auto-launch tmux if not already in a session
    if not set -q TMUX
        and test "$TERM_PROGRAM" != "vscode"
        and status is-login
        # Source the tmux launcher
        source $DOTFILES/tmux/tmux-launcher.fish
        # Auto-attach to existing session or create new one
        tmux-launcher
    end
end

# ============================================================================
# GREETING
# ============================================================================
set -U fish_greeting "🐟"

# opencode
fish_add_path /Users/brendanmullins/.opencode/bin
fish_add_path $HOME/.local/bin
