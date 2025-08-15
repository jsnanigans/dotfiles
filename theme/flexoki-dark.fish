#!/usr/bin/env fish

# Flexoki Dark theme for Fish

# Base colors
set -gx fish_color_normal cecdc3
set -gx fish_color_command 4385be
set -gx fish_color_keyword ce5d97
set -gx fish_color_quote 879a39
set -gx fish_color_redirection 3aa99f
set -gx fish_color_end 3aa99f
set -gx fish_color_error d14d41
set -gx fish_color_param cecdc3
set -gx fish_color_comment 878580
set -gx fish_color_selection --background=cecdc3 --foreground=100f0f
set -gx fish_color_operator 3aa99f
set -gx fish_color_escape ce5d97
set -gx fish_color_autosuggestion 575653
set -gx fish_color_cancel d14d41

# Prompt colors
set -gx fish_color_cwd 879a39
set -gx fish_color_cwd_root d14d41
set -gx fish_color_user 4385be
set -gx fish_color_host 3aa99f
set -gx fish_color_host_remote d0a215

# Git prompt colors
set -gx fish_color_git_clean 879a39
set -gx fish_color_git_staged d0a215
set -gx fish_color_git_dirty d14d41
set -gx fish_color_git_untracked ce5d97
set -gx fish_color_git_ahead 4385be
set -gx fish_color_git_behind af3029

# Completion colors
set -gx fish_pager_color_completion cecdc3
set -gx fish_pager_color_description 878580
set -gx fish_pager_color_prefix 4385be --underline
set -gx fish_pager_color_progress cecdc3 --background=575653
set -gx fish_pager_color_selected_background --background=575653

# History search colors
set -gx fish_color_history_current --bold
set -gx fish_color_search_match --background=575653

# Export theme variables
set -gx FLEXOKI_BLACK 100f0f
set -gx FLEXOKI_RED d14d41
set -gx FLEXOKI_GREEN 879a39
set -gx FLEXOKI_YELLOW d0a215
set -gx FLEXOKI_BLUE 4385be
set -gx FLEXOKI_MAGENTA ce5d97
set -gx FLEXOKI_CYAN 3aa99f
set -gx FLEXOKI_WHITE 878580
set -gx FLEXOKI_BRIGHT_BLACK 575653
set -gx FLEXOKI_BRIGHT_RED af3029
set -gx FLEXOKI_BRIGHT_GREEN 66800b
set -gx FLEXOKI_BRIGHT_YELLOW ad8301
set -gx FLEXOKI_BRIGHT_BLUE 205ea6
set -gx FLEXOKI_BRIGHT_MAGENTA a02f6f
set -gx FLEXOKI_BRIGHT_CYAN 24837b
set -gx FLEXOKI_BRIGHT_WHITE cecdc3