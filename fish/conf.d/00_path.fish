# Centralized PATH configuration
# Loads after 00_environment.fish but before other configs

# Define paths in order of priority
set -l paths

# System essentials
set -a paths \
    /opt/homebrew/bin \
    /usr/local/bin \
    $HOME/.local/bin \
    $HOME/bin

# Language/runtime paths
set -a paths \
    $HOME/.bun/bin \
    $HOME/n/bin \
    $HOME/.rvm/bin \
    $HOME/Library/Python/3.13/bin

# Package managers
set -a paths \
    $HOME/Library/pnpm \
    $HOME/.yarn/bin

# Development tools
set -a paths \
    $HOME/.fastlane/bin \
    $HOME/Projects/depot_tools \
    $HOME/development/flutter/bin \
    /usr/local/gradle/gradle-8.8/bin

# Android SDK
if test -n "$ANDROID_HOME"
    set -a paths \
        $ANDROID_HOME/emulator \
        $ANDROID_HOME/tools \
        $ANDROID_HOME/tools/bin \
        $ANDROID_HOME/platform-tools
end

# Add paths only if they exist
for path in $paths
    if test -d $path
        fish_add_path -g $path
    end
end