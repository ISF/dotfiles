# zsh options and features
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
setopt autocd
setopt extendedglob
setopt cdablevars
setopt nobanghist
setopt interactivecomments
setopt nohup
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
unsetopt beep
bindkey -v

autoload -Uz compinit && compinit
autoload -U promptinit && promptinit
autoload -U colors && colors

# color settings
eval $(dircolors -b)

# completion's configuration
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select=long
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/ivan/.zshrc'

# converting inputrc configuration for zsh
eval "$(sed -n 's/^/bindkey /; s/: / /p' /etc/inputrc)"
eval "$(sed -n 's/^/bindkey /; s/: / /p' ~/.inputrc)"

# Colorful PS1 variable taken from gentoo's bashrc
if [[ ${EUID} == 0 ]] ; then
    PROMPT="%{$fg[red]%}%n@%m %{$fg[blue]%}%1~ %# %{$reset_color%}"
else
    PROMPT="%{$fg[green]%}%n@%m %{$fg[blue]%}%1~ %# %{$reset_color%}"
fi

export EDITOR=$(which vim)
export BROWSER=chromium
export TERM=xterm-256color
export PAGER='less -iR'
export MANPAGER='less -iR'

# Setting CFLAGS and CXXFLAGS if none of them are already defined
if [[ -z $CFLAGS ]]; then
    export CFLAGS="-march=amdfam10 -O2 -pipe"
fi

if [[ -z $CXXFLAGS ]]; then
    export CXXFLAGS="$CFLAGS"
fi

# automatically entering tmux
if [[ -z $(tty | grep /dev/tty) ]]; then # check if is not running on a terminal
    if tmux has-session -t system > /dev/null 2>&1; then
        if [[ -z $TMUX ]]; then
            tmux -2 attach -t system
        else
            # exporting correct terminal, fixes some mutt glitches
            export TERM=screen-256color
        fi
    else
        # create new session (and detach)
        tmux -2 new-session -d -s system
        # create windows
        tmux -2 new-window -t system:1 -n 'weechat' 'weechat-curses' # starting weechat
        # attach
        tmux -2 attach -t system
    fi
fi

# alias
alias ls="ls --color=auto"
alias less='less -iR'
alias callgrind='valgrind --tool=callgrind'
alias tmux='tmux -2'
alias compc='gcc -Wall -Wextra -pedantic -std=c99 -lm -ggdb3'
alias oka='echo valeu'
alias beye='TERM=xterm biew'
