# Centralized PATH configuration
# This file is loaded before config.fish due to conf.d naming

# System-wide paths
set -l paths \
    /opt/homebrew/bin \
    $HOME/.local/bin \
    $HOME/bin

# Language-specific paths
set -a paths \
    $HOME/.bun/bin \
    $HOME/n/bin \
    $HOME/.rvm/bin \
    /Users/brendanmullins/Library/Python/3.13/bin

# Development tools
set -a paths \
    $HOME/.fastlane/bin \
    $HOME/Library/pnpm \
    $HOME/Projects/depot_tools \
    $HOME/development/flutter/bin \
    /usr/local/gradle/gradle-8.8/bin

# Add all paths at once
for path in $paths
    if test -d $path
        fish_add_path $path
    end
end