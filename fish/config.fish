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

# Add paths (using fish_add_path to avoid duplicates)
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/.bun/bin
fish_add_path $HOME/.fastlane/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.rvm/bin
fish_add_path $HOME/bin
fish_add_path $HOME/Library/pnpm
fish_add_path $HOME/Projects/depot_tools
fish_add_path $HOME/development/flutter/bin
fish_add_path $HOME/n/bin
fish_add_path /Users/brendanmullins/Library/Python/3.13/bin
fish_add_path /usr/local/gradle/gradle-8.8/bin

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

    # Initialize tools
    # Ruby environment
    if command -q rbenv
        rbenv init - | source
    end

    # Java environment
    if command -q jenv
        jenv init - | source
    end

    # The fuck
    if command -q thefuck
        thefuck --alias | source
    end

    # ============================================================================
    # ALIASES
    # ============================================================================

    # Config editing
    alias zshconfig "nvim ~/.zshrc"
    alias fishconfig "nvim ~/.config/fish/config.fish"
    alias ohmyzsh "nvim ~/.oh-my-zsh"

    # Editor shortcuts
    alias v nvim
    alias v. "nvim ."
    alias nv "neovide ."
    alias ci code-insiders

    # Package managers
    alias pn pnpm
    alias nr "npm run"
    alias pr "pnpm run"
    # alias er "pnpm run"
    # alias d "er dev"
    # alias dapp "er dev --filter=user-app --ui=stream"
    # alias dpmp "er dev --filter=pmp --ui=stream"
    # alias t "er test"

    # Git
    alias gpn "gp --follow-tags --no-verify"
    alias lz lazygit

    # Git abbreviations (like oh-my-zsh git plugin)
    abbr -a gst 'git status'
    abbr -a gc 'git commit'
    abbr -a gca 'git commit -a'
    abbr -a gcm 'git commit -m'
    abbr -a gco 'git checkout'
    abbr -a gcb 'git checkout -b'
    abbr -a gb 'git branch'
    abbr -a gba 'git branch -a'
    abbr -a gbd 'git branch -d'
    abbr -a gbl 'git blame'
    abbr -a gd 'git diff'
    abbr -a gds 'git diff --staged'
    abbr -a gf 'git fetch'
    abbr -a gl 'git log'
    abbr -a glg 'git log --graph'
    abbr -a gm 'git merge'
    abbr -a gp 'git push'
    abbr -a gpl 'git pull'
    abbr -a gr 'git remote'
    abbr -a gra 'git remote add'
    abbr -a grb 'git rebase'
    abbr -a grbi 'git rebase -i'
    abbr -a grs 'git reset'
    abbr -a grsh 'git reset --hard'
    abbr -a gs 'git stash'
    abbr -a gsa 'git stash apply'
    abbr -a gsp 'git stash pop'
    abbr -a gsl 'git stash list'
    abbr -a ga 'git add'
    abbr -a gaa 'git add --all'
    abbr -a gap 'git add -p'

    # Git worktree extras
    alias gwed "gwe develop"
    alias gwem "gwe main"
    alias gwer "gwe release"
    alias gweq "gwe quick"

    # Android
    alias emulator "/Users/brendanmullinsLibrary/Android/sdk/emulator/emulator"
    alias pixel "/Users/brendanmullinsLibrary/Android/sdk/emulator/emulator -avd Pixel_6_Pro_API_33"

    # The fuck
    alias f fuck

    # Tmux with proper colors
    alias tx "env TERM=screen-256color tmux"

    # MemoryBank aliases
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
    # PLUGIN CONFIGURATION
    # ============================================================================

    # Fisher package manager will handle:
    # - z (directory jumping)
    # - fish-async-prompt
    # - autopair.fish
    # - fzf.fish

    # Install with:
    # fisher install jethrokuan/z
    # fisher install PatrickF1/fzf.fish
    # fisher install jorgebucaran/autopair.fish

    # ============================================================================
    # COMPLETIONS
    # ============================================================================

    # Bun completions
    # Note: Bun's completion file is for bash/zsh, not fish
    # TODO: Generate fish-specific completions for bun

    # Enable fish autosuggestions
    set -g fish_autosuggestion_enabled 1
end
