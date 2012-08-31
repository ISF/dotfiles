################################################################################
# Options
################################################################################

shopt -s autocd
shopt -s cmdhist # better history handling of multi-line commands
shopt -s histappend # append history file instead of rewriting
shopt -s extglob # better shell expansion capability
shopt -s cdspell # correct mispelled directory names when using cd
shopt -u mailwarn
ulimit -c unlimited

unset MAILCHECK

PROMPT_COMMAND='history -a' # always append history between sessions
HISTCONTROL='ignoreboth'

# Setting CFLAGS and CXXFLAGS if none of them are already defined
if [[ -z $CFLAGS ]]; then
    if [[ $(hostname) == "shungokusatsu" ]]; then
        export CFLAGS="-march=amdfam10 -O2 -pipe"
    elif [[ $(hostname) == "hadouken" ]]; then
        export CFLAGS="-march=core2 -O2 -pipe"
    fi
fi

if [[ -z $CXXFLAGS ]]; then
    export CXXFLAGS="$CFLAGS"
fi

# Colorful PS1 variable taken from gentoo's bashrc
if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

export EDITOR=$(which vim)
export BROWSER=chromium
if [[ $TERM != "screen-256color" ]]; then
    export TERM=xterm-256color
fi
export PAGER='less -iR'
export MANPAGER='less -iR'
export PYTHONSTARTUP="$HOME/.pystartup"
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
export JAVA_FONTS='/usr/share/fonts/TTF'
eval $(dircolors -b) # LS_COLORS

################################################################################
# Alias
################################################################################
if ls --color=auto > /dev/null 2>&1; then
    alias ls="ls --color=auto"
    alias l="ls -Bh --color=auto"
    alias la="ls -Ah --color=auto"
    alias ll="ls -lh --color=auto"
    alias lla="ls -Alh --color=auto"
    alias lt="ls -alih --color=auto"
else
    alias l="ls -Bh"
    alias la="ls -Ah"
    alias ll="ls -lh"
    alias lla="ls -Alh"
    alias lt="ls -alih"
fi
alias oka='echo valeu'
alias beye='TERM=xterm biew'
alias less='less -iR'
alias callgrind='valgrind --tool=callgrind'
