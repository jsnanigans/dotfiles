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
    
    # Useful jj aliases
    alias jlog "jj log --limit 10"
    alias jlogg "jj log --graph"
    alias jroot "cd (jj root)"
    
    # Git colocated commands
    abbr -a jgf 'jj git fetch'
    abbr -a jgp 'jj git push'
    abbr -a jgi 'jj git init --colocate'
end