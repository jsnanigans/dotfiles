# Git configuration with abbreviations and aliases

# Core git abbreviations (expand on tab)
abbr -a g git
abbr -a ga 'git add'
abbr -a gaa 'git add --all'
abbr -a gap 'git add -p'
abbr -a gb 'git branch'
abbr -a gba 'git branch -a'
abbr -a gbl 'git blame'
abbr -a gc 'git commit'
abbr -a gca 'git commit -a'
abbr -a gcm 'git commit -m'
abbr -a gco 'git checkout'
abbr -a gcb 'git checkout -b'
abbr -a gd 'git diff'
abbr -a gds 'git diff --staged'
abbr -a gdc 'git diff --cached'
abbr -a gdst 'git diff --stat'
abbr -a gf 'git fetch'
abbr -a gl 'git log'
abbr -a glg 'git log --graph'
abbr -a glf 'git log --follow --'
abbr -a gm 'git merge'
abbr -a gp 'git push'
abbr -a gpn 'git push --follow-tags --no-verify'
abbr -a gpl 'git pull'
abbr -a gr 'git remote'
abbr -a gra 'git remote add'
abbr -a grb 'git rebase'
abbr -a grbi 'git rebase -i'
abbr -a grs 'git reset'
abbr -a grsh 'git reset --hard'
abbr -a grh 'git reset HEAD'
abbr -a grhh 'git reset HEAD --hard'
abbr -a gs 'git stash'
abbr -a gsa 'git stash apply'
abbr -a gsp 'git stash pop'
abbr -a gsl 'git stash list'
abbr -a gst 'git status'

# Enhanced git workflow abbreviations (custom functions)
abbr -a gbdiff git-branch-diff
abbr -a ghunks git-hunks
abbr -a gsi git-stage-interactive
abbr -a gqc git-quick-commit
abbr -a ghelp git-help
abbr -a gh git-help

# Aliases (for commands that need to be functions)
alias lz lazygit

# Git worktree shortcuts
alias gwed "gwe develop"
alias gwem "gwe main"
alias gwer "gwe release"
alias gweq "gwe quick"