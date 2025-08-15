#!/usr/bin/env fish

# Github Dark Colorblind Theme for Fish Shell

# Syntax highlighting colors
set -U fish_color_normal c9d1d9
set -U fish_color_command 79c0ff
set -U fish_color_quote 58a6ff
set -U fish_color_redirection c9d1d9
set -U fish_color_end 39c5cf
set -U fish_color_error ec8e2c
set -U fish_color_param c9d1d9
set -U fish_color_comment 6e7681
set -U fish_color_match --background=c9d1d9
set -U fish_color_selection --background=c9d1d9 --foreground=0d1117
set -U fish_color_search_match --background=c9d1d9 --foreground=0d1117
set -U fish_color_history_current --bold
set -U fish_color_operator 39c5cf
set -U fish_color_escape bc8cff
set -U fish_color_cwd 58a6ff
set -U fish_color_cwd_root ec8e2c
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion 6e7681
set -U fish_color_user 58a6ff
set -U fish_color_host c9d1d9
set -U fish_color_host_remote d29922
set -U fish_color_cancel --reverse

# Pager colors
set -U fish_pager_color_description d29922
set -U fish_pager_color_prefix c9d1d9 --bold --underline
set -U fish_pager_color_progress ffffff --background=39c5cf
set -U fish_pager_color_completion c9d1d9
set -U fish_pager_color_selected_background --background=c9d1d9
set -U fish_pager_color_selected_prefix 0d1117
set -U fish_pager_color_selected_completion 0d1117
set -U fish_pager_color_selected_description 0d1117

# Set LS_COLORS for colorized ls output
set -gx LSCOLORS "exfxcxdxbxegedabagacad"
set -gx LS_COLORS "di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

echo "Github Dark Colorblind theme applied to Fish shell"