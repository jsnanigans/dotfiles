#!/usr/bin/env fish
# Rose Pine Theme for Fish Shell
# Single source of truth for Rose Pine colors

# ============================================================================
# ROSE PINE COLOR PALETTE - Main Variant
# ============================================================================

# Base colors
set -gx ROSE_PINE_BASE "191724"
set -gx ROSE_PINE_SURFACE "1f1d2e"
set -gx ROSE_PINE_OVERLAY "26233a"
set -gx ROSE_PINE_HIGHLIGHT_LOW "21202e"
set -gx ROSE_PINE_HIGHLIGHT_MED "403d52"
set -gx ROSE_PINE_HIGHLIGHT_HIGH "524f67"

# Text colors
set -gx ROSE_PINE_MUTED "6e6a86"
set -gx ROSE_PINE_SUBTLE "908caa"
set -gx ROSE_PINE_TEXT "e0def4"

# Accent colors
set -gx ROSE_PINE_LOVE "eb6f92"
set -gx ROSE_PINE_GOLD "f6c177"
set -gx ROSE_PINE_ROSE "ebbcba"
set -gx ROSE_PINE_PINE "31748f"
set -gx ROSE_PINE_FOAM "9ccfd8"
set -gx ROSE_PINE_IRIS "c4a7e7"

# ============================================================================
# FISH SHELL COLOR CONFIGURATION
# ============================================================================

# Normal text and commands
set -U fish_color_normal $ROSE_PINE_TEXT
set -U fish_color_command $ROSE_PINE_PINE
set -U fish_color_keyword $ROSE_PINE_IRIS
set -U fish_color_quote $ROSE_PINE_ROSE
set -U fish_color_redirection $ROSE_PINE_GOLD --bold
set -U fish_color_end $ROSE_PINE_FOAM
set -U fish_color_error $ROSE_PINE_LOVE
set -U fish_color_param $ROSE_PINE_TEXT
set -U fish_color_comment $ROSE_PINE_MUTED --italics
set -U fish_color_option $ROSE_PINE_SUBTLE
set -U fish_color_operator $ROSE_PINE_IRIS
set -U fish_color_escape $ROSE_PINE_GOLD
set -U fish_color_autosuggestion $ROSE_PINE_MUTED
set -U fish_color_cwd $ROSE_PINE_FOAM
set -U fish_color_cwd_root $ROSE_PINE_LOVE
set -U fish_color_user $ROSE_PINE_PINE
set -U fish_color_host $ROSE_PINE_ROSE
set -U fish_color_host_remote $ROSE_PINE_GOLD
set -U fish_color_status $ROSE_PINE_LOVE
set -U fish_color_cancel --reverse
set -U fish_color_search_match --bold --background=$ROSE_PINE_HIGHLIGHT_MED
set -U fish_color_selection $ROSE_PINE_TEXT --bold --background=$ROSE_PINE_HIGHLIGHT_MED
set -U fish_color_history_current $ROSE_PINE_TEXT --bold
set -U fish_color_valid_path --underline
set -U fish_color_match --background=$ROSE_PINE_HIGHLIGHT_HIGH

# Pager colors
set -U fish_pager_color_completion $ROSE_PINE_TEXT
set -U fish_pager_color_description $ROSE_PINE_SUBTLE
set -U fish_pager_color_prefix $ROSE_PINE_IRIS --bold
set -U fish_pager_color_progress $ROSE_PINE_ROSE --background=$ROSE_PINE_HIGHLIGHT_MED
set -U fish_pager_color_selected_background --background=$ROSE_PINE_HIGHLIGHT_HIGH

# ============================================================================
# ENVIRONMENT VARIABLES FOR OTHER TOOLS
# ============================================================================

# FZF colors
set -gx FZF_DEFAULT_OPTS "
  --color=bg+:#$ROSE_PINE_SURFACE,bg:#$ROSE_PINE_BASE,spinner:#$ROSE_PINE_IRIS
  --color=hl:#$ROSE_PINE_ROSE,fg:#$ROSE_PINE_TEXT,header:#$ROSE_PINE_IRIS
  --color=info:#$ROSE_PINE_FOAM,pointer:#$ROSE_PINE_IRIS,marker:#$ROSE_PINE_LOVE
  --color=fg+:#$ROSE_PINE_TEXT,prompt:#$ROSE_PINE_IRIS,hl+:#$ROSE_PINE_ROSE
  --color=border:#$ROSE_PINE_HIGHLIGHT_HIGH
"

# Bat and Delta themes
set -gx BAT_THEME "rose-pine"
set -gx DELTA_FEATURES "rose-pine"

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

# Function to display all Rose Pine colors
function rose_pine_colors
    echo "Rose Pine Color Palette:"
    echo ""
    echo "Base Colors:"
    echo -e "  base:           \033[48;2;"(string replace -a '#' '' $ROSE_PINE_BASE | sed 's/../0x&;/g' | sed 's/;$//' | xargs printf "%d;%d;%d")"m    \033[0m #$ROSE_PINE_BASE"
    echo -e "  surface:        \033[48;2;"(string replace -a '#' '' $ROSE_PINE_SURFACE | sed 's/../0x&;/g' | sed 's/;$//' | xargs printf "%d;%d;%d")"m    \033[0m #$ROSE_PINE_SURFACE"
    echo -e "  overlay:        \033[48;2;"(string replace -a '#' '' $ROSE_PINE_OVERLAY | sed 's/../0x&;/g' | sed 's/;$//' | xargs printf "%d;%d;%d")"m    \033[0m #$ROSE_PINE_OVERLAY"
    echo ""
    echo "Text Colors:"
    echo -e "  text:           \033[38;2;"(string replace -a '#' '' $ROSE_PINE_TEXT | sed 's/../0x&;/g' | sed 's/;$//' | xargs printf "%d;%d;%d")"mSample Text\033[0m #$ROSE_PINE_TEXT"
    echo -e "  subtle:         \033[38;2;"(string replace -a '#' '' $ROSE_PINE_SUBTLE | sed 's/../0x&;/g' | sed 's/;$//' | xargs printf "%d;%d;%d")"mSample Text\033[0m #$ROSE_PINE_SUBTLE"
    echo -e "  muted:          \033[38;2;"(string replace -a '#' '' $ROSE_PINE_MUTED | sed 's/../0x&;/g' | sed 's/;$//' | xargs printf "%d;%d;%d")"mSample Text\033[0m #$ROSE_PINE_MUTED"
    echo ""
    echo "Accent Colors:"
    echo -e "  love:           \033[38;2;"(string replace -a '#' '' $ROSE_PINE_LOVE | sed 's/../0x&;/g' | sed 's/;$//' | xargs printf "%d;%d;%d")"mSample Text\033[0m #$ROSE_PINE_LOVE"
    echo -e "  gold:           \033[38;2;"(string replace -a '#' '' $ROSE_PINE_GOLD | sed 's/../0x&;/g' | sed 's/;$//' | xargs printf "%d;%d;%d")"mSample Text\033[0m #$ROSE_PINE_GOLD"
    echo -e "  rose:           \033[38;2;"(string replace -a '#' '' $ROSE_PINE_ROSE | sed 's/../0x&;/g' | sed 's/;$//' | xargs printf "%d;%d;%d")"mSample Text\033[0m #$ROSE_PINE_ROSE"
    echo -e "  pine:           \033[38;2;"(string replace -a '#' '' $ROSE_PINE_PINE | sed 's/../0x&;/g' | sed 's/;$//' | xargs printf "%d;%d;%d")"mSample Text\033[0m #$ROSE_PINE_PINE"
    echo -e "  foam:           \033[38;2;"(string replace -a '#' '' $ROSE_PINE_FOAM | sed 's/../0x&;/g' | sed 's/;$//' | xargs printf "%d;%d;%d")"mSample Text\033[0m #$ROSE_PINE_FOAM"
    echo -e "  iris:           \033[38;2;"(string replace -a '#' '' $ROSE_PINE_IRIS | sed 's/../0x&;/g' | sed 's/;$//' | xargs printf "%d;%d;%d")"mSample Text\033[0m #$ROSE_PINE_IRIS"
end