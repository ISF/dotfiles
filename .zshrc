################################################################################
# ZSH options and features
################################################################################
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
setopt autocd
setopt autopushd
setopt pushdignoredups
setopt cdablevars
setopt completeinword
setopt alwaystoend
setopt extendedglob
setopt histignoredups
setopt histignorespace
setopt histreduceblanks
setopt interactivecomments
setopt incappendhistory
setopt sharehistory
setopt nobanghist
setopt nobeep
setopt nocheckjobs
setopt nohup
setopt notify
setopt prompt_subst
setopt autolist
setopt listtypes

autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -Uz vcs_info

# color settings
eval $(dircolors -b)

################################################################################
# vcs_info configuration
################################################################################

# do not chang the order of vcs below, otherwise it won't detect non-git repos
# in home (there exists a git repo with dotfiles)
zstyle ':vcs_info:*' enable hg svn git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '[%s@%b]'
zstyle ':vcs_info:git:*' actionformats '[%s@%b|%a]'
zstyle ':vcs_info:hg:*' formats '[%s@%b]'
zstyle ':vcs_info:hg:*' actionformats '[%s@%b|%a]'

################################################################################
# completion's configuration
################################################################################
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' menu select=long
zstyle ':completion:*' original true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
zstyle :compinstall filename '/home/ivan/.zshrc'

################################################################################
# hooks
################################################################################

precmd () {
    vcs_info
}

################################################################################
# bindings and zle configuration
################################################################################

# vi mode
bindkey -v

# converting inputrc configuration for zsh
eval "$(sed -n 's/^/bindkey /; s/: / /p' /etc/inputrc)"
eval "$(sed -n 's/^/bindkey /; s/: / /p' ~/.inputrc)"

# use backspace over everythin on vi mode
bindkey -M viins '' backward-delete-char
bindkey -M viins '' backward-delete-char

################################################################################
# variables
################################################################################

if [[ ${EUID} == 0 ]] ; then
    PROMPT='%{$fg[red]%}%n@%m %{$fg[blue]%}%1~ %# %{$reset_color%}'
else
    PROMPT='%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%1~ %# %{$reset_color%}'
    RPROMPT='%{$fg_bold[green]%}${vcs_info_msg_0_}%{$reset_color%}'
fi

export EDITOR=$(which vim)
export BROWSER=chromium
export TERM=xterm-256color
export PAGER='less -iR'
export MANPAGER='less -iR'

# setting CFLAGS and CXXFLAGS if none of them are already defined
if [[ -z $CFLAGS ]]; then
    export CFLAGS="-march=amdfam10 -O2 -pipe"
fi

if [[ -z $CXXFLAGS ]]; then
    export CXXFLAGS="$CFLAGS"
fi

################################################################################
# alias
################################################################################

# common
alias l="ls -Bh --color=auto"
alias la="ls -Ah --color=auto"
alias ll="ls -lh --color=auto"
alias lt="ls -alih --color=auto"
alias less='less -iR'
alias callgrind='valgrind --tool=callgrind'
alias tmux='tmux -2'
alias compc='gcc -Wall -Wextra -pedantic -std=c99 -lm -ggdb3'
alias oka='echo valeu'
alias beye='TERM=xterm biew'

# suffix
alias -s html=$BROWSER
alias -s png='display'
alias -s jpg='display'
alias -s txt=$EDITOR

################################################################################
# automatically entering tmux (this must be the last section)
################################################################################

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
