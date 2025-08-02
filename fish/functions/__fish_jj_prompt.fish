function __fish_jj_prompt --description 'Write out the jj prompt'
    # Check if we're in a jj repo
    if not command -sq jj
        return 1
    end
    
    # Get all the info in one command with clear separators
    set -l jj_info (jj log --no-graph -r @ \
        -T 'change_id.shortest() ++ "|" ++ if(empty, "EMPTY", "HASCHANGES") ++ "|" ++ if(conflict, "CONFLICT", "NOCONFLICT") ++ "|" ++ bookmarks.join(",") ++ "|" ++ description.first_line()' \
        2>/dev/null)
    
    if test -z "$jj_info"
        return 1
    end
    
    # Split by our delimiter
    set -l parts (string split '|' $jj_info)
    if test (count $parts) -lt 4
        return 1
    end
    
    set -l change_id $parts[1]
    set -l is_empty $parts[2]
    set -l has_conflict $parts[3]
    set -l bookmarks_str $parts[4]
    set -l description ""
    if test (count $parts) -ge 5
        set description $parts[5]
    end
    
    # Parse bookmarks if any
    set -l bookmarks
    if test -n "$bookmarks_str"
        set bookmarks (string split ',' $bookmarks_str)
    end
    
    # Build prompt
    echo -n ' ('
    
    # Show bookmarks first if they exist, otherwise show change ID
    if test (count $bookmarks) -gt 0
        # Show bookmarks
        set_color $__fish_jj_prompt_color_bookmark
        echo -n (string join ', ' $bookmarks)
        set_color normal
    else
        # No bookmarks, show change ID
        set_color $__fish_jj_prompt_color_change_id
        echo -n $change_id
        set_color normal
        
        # Show description if it exists
        if test -n "$description"
            echo -n ' '
            set_color $fish_color_comment
            # Truncate description if too long
            set -l desc_display (string sub -l 20 $description)
            if test (string length $description) -gt 20
                set desc_display "$desc_display…"
            end
            echo -n $desc_display
            set_color normal
        end
    end
    
    # Status indicators
    if test "$is_empty" = "HASCHANGES"
        set_color $__fish_jj_prompt_color_dirty
        echo -n ' ●'
        set_color normal
    end
    
    if test "$has_conflict" = "CONFLICT"
        set_color $__fish_jj_prompt_color_conflict
        echo -n ' ✗'
        set_color normal
    end
    
    echo -n ')'
end