################################################################################
# ZSH options and features
################################################################################
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

setopt always_to_end
setopt append_history
setopt auto_cd
setopt auto_list
setopt auto_menu
setopt auto_name_dirs
setopt auto_pushd
setopt cdablevars
setopt completeinword
setopt correct
setopt extended_glob
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt interactive_comments
setopt list_ambiguous
setopt list_types
setopt nohup
setopt notify
setopt prompt_subst
setopt pushd_ignore_dups
setopt share_history
unsetopt banghist
unsetopt beep
unsetopt checkjobs

fpath=($HOME/.zsh/functions/ $fpath)

# my functions

autoload kernel_symbol

# global functions
autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -Uz vcs_info
autoload -Uz zsh-mime-setup && zsh-mime-setup

# color settings for ls
eval $(dircolors -b)

################################################################################
# variables
################################################################################

# for reference while compiling vim
VIMCFG="./configure --prefix=/usr --localstatedir=/var/lib/vim \
--mandir=/usr/share/man --with-compiledby=ArchLinux \
--with-features=huge --enable-gpm --enable-acl --with-x=yes \
--disable-gui --enable-multibyte --enable-cscope \
--enable-netbeans --disable-perlinterp --enable-pythoninterp \
--disable-rubyinterp --enable-luainterp"

if [[ ${EUID} == 0 ]] ; then
    PROMPT='%{$fg[red]%}%n@%m %{$fg[blue]%}[${VIMODE}] %~ %# %{$reset_color%}'
else
    PROMPT='%{$fg_bold[green]%}%n@%m %{$fg[blue]%}[${VIMODE}] %~ %# %{$reset_color%}'
    RPROMPT='${vcs_info_msg_0_}'
fi

export EDITOR=$(which vim)
export BROWSER=chromium
export TERM=xterm-256color
export PAGER='less -iR'
export MANPAGER='less -iR'
export PYTHONSTARTUP="$HOME/.pystartup"

# setting CFLAGS and CXXFLAGS if none of them are already defined
if [[ -z $CFLAGS ]]; then
    export CFLAGS="-march=amdfam10 -O2 -pipe"
fi

if [[ -z $CXXFLAGS ]]; then
    export CXXFLAGS="$CFLAGS"
fi

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
zstyle ':completion:*' menu select
zstyle ':completion:*' original true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"
zstyle :compinstall filename '/home/ivan/.zshrc'

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# use /etc/hosts and known_hosts for hostname completion
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  `hostname`
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

################################################################################
# functions
################################################################################

ARG=1 # variable used to emulate readline's alt+control+y

function take_nth_arg {
    zle insert-last-word -- -1 $ARG -
    ARG=$(($ARG+1))
}
zle -N take_nth_arg

# taken and modified from http://zshwiki.org/home/examples/zlewidgets
function zle-line-init zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/n}/(main|viins)/i}"
    zle reset-prompt
    ARG=1
}
zle -N zle-line-init
zle -N zle-keymap-select

# needed for mode changing (viins and vicmd)
function zle-line-finish {
    VIMODE="${${KEYMAP/vicmd/n}/(main|viins)/i}"
    zle reset-prompt
}

zle-isearch-update() {
    zle -M "Line $HISTNO"
}
zle -N zle-isearch-update

zle-isearch-exit() {
    zle -M ""
}
zle -N zle-isearch-exit

function precmd {
    vcs_info
}

function zathura {
    command zathura $@ &
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

bindkey "" vi-up-line-or-history
bindkey "" vi-down-line-or-history

bindkey "^[[1~" vi-beginning-of-line   # Home
bindkey "^[[4~" vi-end-of-line         # End
bindkey '^[[2~' beep                   # Insert
bindkey '^[[3~' delete-char            # Del
bindkey '^[[5~' vi-backward-blank-word # Page Up
bindkey '^[[6~' vi-forward-blank-word  # Page Down

# normal C-R for history search
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey -M viins '^e' history-incremental-pattern-search-backward
bindkey -M vicmd '^e' history-incremental-pattern-search-backward

# control+u erase entire line on vicmd
bindkey -M vicmd '^u' kill-whole-line # dd can be used also

# alt+. to complete previous args
bindkey -M viins '\e.' insert-last-word
bindkey -M viins '\e,' take_nth_arg

# ensure that arrow keys work as they should
bindkey '\e[A' up-line-or-history
bindkey '\e[B' down-line-or-history

bindkey '\eOA' up-line-or-history
bindkey '\eOB' down-line-or-history

bindkey '\e[C' forward-char
bindkey '\e[D' backward-char

bindkey '\eOC' forward-char
bindkey '\eOD' backward-delete-charward-char

################################################################################
# alias
################################################################################

# common
alias ls="ls --color=auto"
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
alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias rm='nocorrect rm'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias sz='source ~/.zshrc'
alias ez="$EDITOR ~/.zshrc"

# suffix
alias -s html=$BROWSER
alias -s png='display'
alias -s jpg='display'
alias -s txt=$EDITOR
alias -s pdf='zathura'

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
