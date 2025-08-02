# Fish Shell Configuration
# Migrated from .zshrc

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# Set default editor
if test -n "$SSH_CONNECTION"
    set -gx EDITOR vim
else
    set -gx EDITOR nvim
end

# Set NVIM_APPNAME
set -gx NVIM_APPNAME marvim

# Dotfiles directory
set -gx DOTFILES $HOME/dotfiles

# Bat config
set -gx BAT_CONFIG_PATH $DOTFILES/bat/bat.conf

# API Keys (empty by default)
set -gx GEMINI_API_KEY ""

# Android and iOS development
set -gx ANDROID_HOME /Users/brendanmullins/Library/Android/sdk
set -gx IOS_API_FILE_PATH /Users/brendanmullins/app_cert/old/AuthKey_TT439J2PCV.p8
set -gx IOS_API_KEY_ID TT439J2PCV

# MemoryBank configuration
set -gx MB_ROOT /Users/brendanmullins/Documents/Obsidian/MCP/MCP/MemoryBank
set -gx MB_TEMPLATES $MB_ROOT/_System/templates

# ============================================================================
# PATH CONFIGURATION
# ============================================================================
# PATH configuration moved to conf.d/00_path.fish for better organization

# BUN installation
set -gx BUN_INSTALL $HOME/.bun

# N prefix
set -gx N_PREFIX $HOME/n

# PNPM home
set -gx PNPM_HOME $HOME/Library/pnpm

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
    # ALIASES
    # ============================================================================
    # Aliases moved to conf.d/aliases.fish for better organization
    
    # The fuck shortcut remains here due to lazy loading dependency
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
    # COMPLETIONS & PLUGINS
    # ============================================================================
    # Plugin configuration handled by conf.d/ files
    # Enable fish autosuggestions
    set -g fish_autosuggestion_enabled 1
end

set -U fish_greeting "🐟"
