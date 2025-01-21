# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/brendanmullins/.zsh/completions:"* ]]; then export FPATH="/Users/brendanmullins/.zsh/completions:$FPATH"; fi
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/dotfiles/zsh

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z fast-syntax-highlighting zsh-autosuggestions git-extras cic)
# zsh-autosuggestions zsh-autocomplete

source $ZSH/oh-my-zsh.sh


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Add bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH

eval $(thefuck --alias)
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
export NVIM_APPNAME=lzvim
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias v="nvim"
alias er="pnpm run"
alias d="er dev"
alias dapp="er dev --filter=user-app --ui=stream"
alias dpmp="er dev --filter=pmp --ui=stream"
alias t="er test"
alias tx="env TERM=screen-256color tmux"
# git
alias gpn="gp --follow-tags --no-verify"
alias lz="lazygit"

# jli
alias j="bun /Users/bdan/rad/jli/index.ts"
alias jf="j feat -t"
alias jc="j commit -m"

alias v.="v ."

alias nv="neovide ."

alias pn="pnpm"

alias ci="code-insiders"

alias emulator="/Users/bdan/Library/Android/sdk/emulator/emulator"
alias pixel="/Users/bdan/Library/Android/sdk/emulator/emulator -avd Pixel_6_Pro_API_33"
alias f="fuck"

# yazi

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add fastlane to path
export PATH="$HOME/.fastlane/bin:$PATH"
export PATH=/Users/bdan/.local/bin:$PATH
export PATH="/usr/local/gradle/gradle-8.8/bin:$PATH"


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
eval "$(rbenv init - zsh)"

# bun completions
[ -s "/Users/bdan/.bun/_bun" ] && source "/Users/bdan/.bun/_bun"

# bit
case ":$PATH:" in
  *":/Users/bdan/bin:"*) ;;
  *) export PATH="$PATH:/Users/bdan/bin" ;;
esac
# bit end

# pnpm
export PNPM_HOME="/Users/bdan/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$PATH:/Users/bdan/Projects/depot_tools"
export ANDROID_HOME="/Users/bdan/Library/Android/sdk"
export IOS_API_FILE_PATH="/Users/brendanmullins/app_cert/old/AuthKey_TT439J2PCV.p8"
export IOS_API_KEY_ID="TT439J2PCV"


### JVENV ###
eval "$(jenv init -)"

#compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: gt completion >> ~/.zshrc
#    or gt completion >> ~/.zprofile on OSX.
#
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt
###-end-gt-completions-###


export PATH=$HOME/development/flutter/bin:$PATH

# n
export N_PREFIX=$HOME/n
export PATH=$N_PREFIX/bin:$PATH

export ZELLIJ_CONFIG_DIR=$HOME/dotfiles/zellij
. "/Users/brendanmullins/.deno/env"
# Initialize zsh completions (added by deno install script)
autoload -Uz compinit
compinit

export BAT_CONFIG_PATH="$HOME/dotfiles/bat/bat.conf"

export CAPGO_API_KEY="a0250313-3bc6-4d14-8cdd-25f48524b19b"
export ARCHIVE_BASE_URL="https://app-archive.dev.join9am.com"
export ARCHIVE_S3_BUCKET="userfrontenddevus-archivedistributionbucket-jxy9ut4iujvi"
