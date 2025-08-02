function __fish_jj_prompt --description 'Write out the jj prompt'
    # Check if we're in a jj repo (cached check)
    if not command -sq jj
        return 1
    end
    
    # Use a single jj command to get all info we need
    set -l jj_status (jj log --no-graph -r @ \
        -T 'separate(" ", change_id.shortest(), if(conflict, "CONFLICT"), if(empty, "", "DIRTY"), bookmarks)' \
        2>/dev/null)
    
    if test -z "$jj_status"
        return 1
    end
    
    # Parse the output
    set -l parts (string split ' ' $jj_status)
    if test (count $parts) -lt 1
        return 1
    end
    
    set -l change_id $parts[1]
    set -l has_conflicts 0
    set -l has_changes 0
    set -l bookmarks
    
    # Process remaining parts
    for i in (seq 2 (count $parts))
        switch $parts[$i]
            case CONFLICT
                set has_conflicts 1
            case DIRTY
                set has_changes 1
            case '*'
                # Everything else is a bookmark
                set -a bookmarks $parts[$i]
        end
    end
    
    # Build prompt
    echo -n ' ('
    
    # Change ID
    set_color $__fish_jj_prompt_color_change_id
    echo -n $change_id
    set_color normal
    
    # Bookmarks
    if test (count $bookmarks) -gt 0
        echo -n ' '
        set_color $__fish_jj_prompt_color_bookmark
        echo -n (string join ', ' $bookmarks)
        set_color normal
    end
    
    # Status indicators
    if test $has_changes -eq 1
        set_color $__fish_jj_prompt_color_dirty
        echo -n ' ●'
        set_color normal
    end
    
    if test $has_conflicts -eq 1
        set_color $__fish_jj_prompt_color_conflict
        echo -n ' ✗'
        set_color normal
    end
    
    echo -n ')'
end