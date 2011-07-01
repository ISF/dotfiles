# zsh options and features
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
setopt autocd
setopt extendedglob
setopt cdablevars
unsetopt beep
bindkey -v

# used for completion
autoload -Uz compinit && compinit

# helps selecting a prompt theme
autoload -U promptinit && promptinit

# color settings
eval $(dircolors -b)
autoload -U colors && colors

# Colorful PS1 variable taken from gentoo's bashrc
if [[ ${EUID} == 0 ]] ; then
else
    PROMPT="%{$fg[green]%}%n@%m %{$fg[blue]%}%1~ %# %{$reset_color%}"
fi

export EDITOR=$(which vim)
export BROWSER=chromium
export TERM=xterm-256color

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
