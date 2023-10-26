# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:$HOME/DevUtils/homebrew/bin:/usr/local/bin:$HOME/.jenv/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:$HOME/.cargo/bin:$PATH
#
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

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
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 7

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
COMPLETION_WAITING_DOTS="true"

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
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Some plugins require manual installation:
# git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
# git clone https://github.com/esc/conda-zsh-completion ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/conda-zsh-completion
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

plugins=(vi-mode tmux history-substring-search zsh-autosuggestions command-not-found git nvm conda-zsh-completion jira dirhistory web-search colored-man-pages pj mvn fzf fzf-tab kubectl kubectx)

# User configuration

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_UNICODE=true
ZSH_TMUX_DEFAULT_SESSION_NAME="primary"
ZSH_TMUX_FIXTERM=false
PROJECT_PATHS=(~/dhdev ~/bin)
export NVM_HOMEBREW=$(brew --prefix nvm)
zstyle ':completion::complete:*' use-cache 1
zstyle ':conda_zsh_completion:*' use-groups true
zstyle 'omz:plugins:nvm' lazy yes
zstyle 'omz:plugins:nvm' lazy-cmd eslint prettier typescript
zstyle 'omz:plugins:nvm' autoload yes
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# # set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# # set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# # preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# # switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

source $ZSH/oh-my-zsh.sh

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
alias zshconf="vim ~/.zshrc"
alias vimconf="vim ~/.vimrc"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
unalias la
alias ls=lsd
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
export HOMEBREW_PREFIX="$HOME/DevUtils/homebrew"
export JIRA_URL="https://diameterhealth.atlassian.net"
export JIRA_RAPID_BOARD=true
export JIRA_NAME="Michael Lang"
export NODE_PATH=$(npm root -g)
export PAGER=less
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export PROMPT_EOL_MARK=
# eval `gdircolors ~/.dir_colors`

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

timezsh() {
    shell=${1-$SHELL}
    for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}


# Allow ctrl-z to toggle between suspend and resume
function Resume() {
    fg
    zle push-input
    BUFFER=""
    zle accept-line
}
zle -N Resume
bindkey "^Z" Resume

la() {
    ls -alh --color=always "$@" | less -R;
}

battail() {
    tail -f "$@" | bat --paging=never -l log
}

tiltdo() {
    (pj fusion/docker && tilt "$@")
}

alias bathelp='bat --plain --language=help'
help() {
    "$@" --help 2>&1 | bathelp
}

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`
export NODE_EXTRA_CA_CERTS="$HOME/.dh/mitm.crt"
export DEV_ENV="availity"
export REQUESTS_CA_BUNDLE="$HOME/.dh/mitm.crt"
export NODE_EXTRA_CA_CERTS="$HOME/.dh/mitm.crt"
export DEV_ENV="availity"
export REQUESTS_CA_BUNDLE="$HOME/.dh/mitm.crt"

eval export PATH="/Users/michael.lang/.jenv/shims:${PATH}"
export JENV_SHELL=zsh
export JENV_LOADED=1
unset JAVA_HOME
unset JDK_HOME
source '/Users/michael.lang/DevUtils/homebrew/Cellar/jenv/0.5.6/libexec/libexec/../completions/jenv.zsh'
jenv rehash 2>/dev/null
jenv refresh-plugins >/dev/null
jenv() {
  type typeset &> /dev/null && typeset command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  enable-plugin|rehash|shell|shell-options)
    eval `jenv "sh-$command" "$@"`;;
  *)
    command jenv "$command" "$@";;
  esac
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/michael.lang/DevUtils/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/michael.lang/DevUtils/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/Users/michael.lang/DevUtils/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="$PATH:/Users/michael.lang/DevUtils/homebrew/Caskroom/miniconda/base/bin"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(direnv hook zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
