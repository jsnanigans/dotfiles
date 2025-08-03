# Rose Pine theme colors for Fish shell

# Base colors
set -U fish_color_normal e0def4                          # text
set -U fish_color_command 31748f                         # pine
set -U fish_color_keyword c4a7e7                         # iris
set -U fish_color_quote ebbcba                           # rose
set -U fish_color_redirection f6c177 --bold              # gold
set -U fish_color_end 9ccfd8                             # foam
set -U fish_color_error eb6f92                           # love
set -U fish_color_param e0def4                           # text
set -U fish_color_comment 6e6a86 --italics               # muted
set -U fish_color_option 908caa                          # subtle
set -U fish_color_operator c4a7e7                        # iris
set -U fish_color_escape f6c177                          # gold
set -U fish_color_autosuggestion 6e6a86                  # muted
set -U fish_color_cwd 9ccfd8                             # foam
set -U fish_color_cwd_root eb6f92                        # love
set -U fish_color_user 31748f                            # pine
set -U fish_color_host ebbcba                            # rose
set -U fish_color_host_remote f6c177                     # gold
set -U fish_color_status eb6f92                          # love
set -U fish_color_cancel --reverse
set -U fish_color_search_match --bold --background=403d52 # highlight_med
set -U fish_color_selection e0def4 --bold --background=403d52 # text on highlight_med
set -U fish_color_history_current e0def4 --bold          # text
set -U fish_color_valid_path --underline
set -U fish_color_match --background=524f67              # highlight_high

# Pager colors
set -U fish_pager_color_completion e0def4                # text
set -U fish_pager_color_description 908caa               # subtle
set -U fish_pager_color_prefix c4a7e7 --bold             # iris
set -U fish_pager_color_progress ebbcba --background=403d52 # rose on highlight_med
set -U fish_pager_color_selected_background --background=524f67 # highlight_high