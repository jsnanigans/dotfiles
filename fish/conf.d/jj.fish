# Jujutsu (jj) configuration and aliases

# Only set up if jj is installed
if command -sq jj
    # Common jj abbreviations
    abbr -a j jj
    abbr -a jst 'jj status'
    abbr -a jl 'jj log'
    abbr -a jd 'jj diff'
    abbr -a jn 'jj new'
    abbr -a je 'jj edit'
    abbr -a jc 'jj commit'
    abbr -a jde 'jj describe'
    abbr -a jb 'jj bookmark'
    abbr -a jbl 'jj bookmark list'
    abbr -a jbc 'jj bookmark create'
    abbr -a jbd 'jj bookmark delete'
    abbr -a jr 'jj rebase'
    abbr -a jm 'jj merge'
    abbr -a js 'jj squash'
    abbr -a jsp 'jj split'
    abbr -a jab 'jj abandon'
    abbr -a jres 'jj resolve'
    abbr -a jevo 'jj evolog'
    abbr -a jop 'jj op log'
    abbr -a jou 'jj op undo'
    
    # Useful jj aliases
    alias jlog "jj log --limit 10"
    alias jlogg "jj log --graph"
    alias jroot "cd (jj root)"
    
    # Cleanup alias - removes all empty changes
    alias jjclean "jj log --no-graph -r 'empty()' -T 'change_id' | xargs -n1 jj abandon"
    
    # Quick workflow aliases
    alias jfinish "jj describe && jj git push"
    alias jsync "jj git fetch && jj log --limit 5"
    
    # Git colocated commands
    abbr -a jgf 'jj git fetch'
    abbr -a jgp 'jj git push'
    abbr -a jgi 'jj git init --colocate'
    abbr -a jgpb 'jj git push --bookmark'
    
    # Navigation shortcuts
    abbr -a j- 'jj edit @-'
    abbr -a j-- 'jj edit @--'
    abbr -a j+ 'jj edit @+'
    abbr -a j++ 'jj edit @++'
end