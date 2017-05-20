################################################################################
# Options
################################################################################

shopt -s autocd
shopt -s cmdhist # better history handling of multi-line commands
shopt -s histappend # append history file instead of rewriting
shopt -s extglob # better shell expansion capability
shopt -s cdspell # correct mispelled directory names when using cd
shopt -u mailwarn

unset MAILCHECK

PROMPT_COMMAND='history -a' # always append history between sessions
HISTCONTROL='ignoreboth'


# Colorful PS1 variable taken from gentoo's bashrc
if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
    if [[ -z $SSH_CLIENT ]]; then
        PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
    else
        PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\](ssh) \w \$\[\033[00m\] '
    fi
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

# alias

source $HOME/.shell_aliases
