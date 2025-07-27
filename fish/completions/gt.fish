# GT completions for Fish
# This will load dynamic completions from gt itself

function __fish_gt_complete
    set -l comp_line (commandline -cp)
    set -l comp_words (string split ' ' -- $comp_line)
    set -l comp_cword (math (count $comp_words) - 1)
    
    # Set environment variables expected by gt
    set -x COMP_LINE "$comp_line"
    set -x COMP_POINT (string length "$comp_line")
    set -x COMP_CWORD "$comp_cword"
    
    # Get completions from gt
    gt --get-yargs-completions $comp_words
end

complete -c gt -f -a '(__fish_gt_complete)'