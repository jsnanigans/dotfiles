function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status

    # Initialize VCS prompt settings once
    if not set -q __fish_vcs_prompt_initialized
        # Git settings
        set -g __fish_git_prompt_show_informative_status 1
        set -g __fish_git_prompt_showdirtystate 1
        set -g __fish_git_prompt_showstashstate 1
        set -g __fish_git_prompt_showuntrackedfiles 1
        set -g __fish_git_prompt_showupstream informative
        set -g __fish_git_prompt_describe_style branch
        
        # Git colors - Rose Pine theme
        set -g __fish_git_prompt_color_branch c4a7e7 --bold  # iris
        set -g __fish_git_prompt_color_dirtystate f6c177     # gold
        set -g __fish_git_prompt_color_stagedstate 9ccfd8    # foam
        set -g __fish_git_prompt_color_invalidstate eb6f92   # love
        set -g __fish_git_prompt_color_untrackedfiles 908caa # subtle
        set -g __fish_git_prompt_color_cleanstate 31748f     # pine
        
        # JJ colors - Rose Pine theme
        set -g __fish_jj_prompt_color_change_id 9ccfd8 --bold    # foam
        set -g __fish_jj_prompt_color_bookmark c4a7e7 --bold     # iris
        set -g __fish_jj_prompt_color_dirty f6c177               # gold
        set -g __fish_jj_prompt_color_conflict eb6f92 --bold     # love
        
        set -g __fish_vcs_prompt_initialized 1
    end

    # Determine prompt character and color
    set -l color_cwd $fish_color_cwd
    set -l suffix '$'
    if functions -q fish_is_root_user; and fish_is_root_user
        set color_cwd $fish_color_cwd_root
        set suffix '#'
    end

    # PWD
    set_color $color_cwd
    echo -n (prompt_pwd)
    set_color normal

    # VCS prompt - try jj first, then git
    set -l vcs_prompt
    if functions -q __fish_jj_prompt
        set vcs_prompt (__fish_jj_prompt)
    end
    
    if test -z "$vcs_prompt"
        set vcs_prompt (fish_vcs_prompt)
    end
    
    if test -n "$vcs_prompt"
        printf '%s ' $vcs_prompt
    end

    # Status
    if test $__fish_last_status -ne 0
        set_color $fish_color_error
        echo -n "[$__fish_last_status] "
        set_color normal
    end

    echo -n "$suffix "
end