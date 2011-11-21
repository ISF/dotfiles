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
setopt list_packed
setopt list_rows_first
setopt nohup
setopt notify
setopt prompt_subst
setopt pushd_ignore_dups
setopt share_history
unsetopt banghist
unsetopt beep
unsetopt checkjobs
unsetopt menu_complete

fpath=($HOME/.zsh/functions/
       $HOME/.zsh/systemctl/
       /usr/share/doc/task/scripts/zsh
       $fpath)

# my functions

autoload tmux_init
autoload kernel_symbol

# global functions
autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -Uz vcs_info
autoload -Uz zsh-mime-setup && zsh-mime-setup

# color settings for ls
eval $(dircolors -b)
eval $(dircolors /home/ivan/.zsh/dircolors.256dark)

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

export PATH=$HOME/.scripts:$PATH
export EDITOR=$(which vim)
export BROWSER=chromium
if [[ $TERM == "screen-256color" ]]; then
    export TERM="screen-256color"
else
    export TERM=xterm-256color
fi
export PAGER='less -iR'
export MANPAGER='less -iR'
export PYTHONSTARTUP="$HOME/.pystartup"
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on"
export JAVA_FONTS='/usr/share/fonts/TTF'

export LESS_TERMCAP_mb=$(printf "\e[1;31m")
export LESS_TERMCAP_md=$(printf "\e[1;38;5;74m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[38;5;246m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[04;38;5;146m")

# setting CFLAGS and CXXFLAGS if none of them are already defined
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

# locale
[[ -z $LANG ]] && export LANG=pt_BR.UTF-8
[[ -z $LC_CTYPE ]] && export LC_CTYPE=pt_BR.UTF-8
[[ -z $LC_NUMERIC ]] && export LC_NUMERIC=pt_BR.UTF-8
[[ -z $LC_COLLATE ]] && export LC_COLLATE=pt_BR.UTF-8
[[ -z $LC_TIME ]] && export LC_TIME=pt_BR.UTF-8
[[ -z $LC_MONETARY ]] && export LC_MONETARY=pt_BR.UTF-8
[[ -z $LC_MESSAGES ]] && export LC_MESSAGES=pt_BR.UTF-8
[[ -z $LC_PAPER ]] && export LC_PAPER=pt_BR.UTF-8
[[ -z $LC_NAME ]] && export LC_NAME=pt_BR.UTF-8
[[ -z $LC_ADDRESS ]] && export LC_ADDRESS=pt_BR.UTF-8
[[ -z $LC_TELEPHONE ]] && export LC_TELEPHONE=pt_BR.UTF-8
[[ -z $LC_MEASUREMENT ]] && export LC_MEASUREMENT=pt_BR.UTF-8
[[ -z $LC_IDENTIFICATION ]] && export LC_IDENTIFICATION=pt_BR.UTF-8
[[ -z $LC_ALL ]] && export LC_ALL=pt_BR.UTF-8

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

# function to run rehash before every completion
# useful when something new must completed
function _force_rehash {
    (( CURRENT == 1 )) && rehash
    return 1 # Because we didn't really complete anything
}

zstyle ':completion:*' completer _force_rehash _complete _prefix _match _ignored _correct _files

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   false
zstyle ':completion:*:man:*'      menu yes select=3

# never user old style completion
zstyle ':completion:*' use-compctl false

zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*:correct:*' insert-unambiguous true
zstyle ':completion:*' menu select=30 # minimum number of possible matches to switch to menu completion
zstyle ':completion:*' original true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 only
zstyle ':completion:*:functions' ignored-patterns '_*'

# directory completion
zstyle ':completion:*' special-dirs .. # complete parent directory

# better kill completion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
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
bindkey -M viins '^_' backward-delete-char
bindkey -M viins '^h' backward-delete-char

# emacs style movements on viins
bindkey -M viins "^a"  vi-beginning-of-line
bindkey -M viins "^e"  vi-end-of-line
bindkey -M viins "\ef" forward-word
bindkey -M viins "\eb" backward-word
bindkey -M viins "^f"  forward-char
bindkey -M viins "^b"  backward-char
bindkey -M viins "^y"  yank
bindkey -M viins "\ey" yank-pop
bindkey -M viins "^t"  transpose-chars
bindkey -M vicmd "^t"  transpose-chars
bindkey -M viins "\et" transpose-words
bindkey -M vicmd "\et" transpose-words
bindkey -M viins "^x*" expand-word

bindkey "^p" vi-up-line-or-history
bindkey "^n" vi-down-line-or-history

bindkey '\e[1~' vi-beginning-of-line   # Home
bindkey '\e[4~' vi-end-of-line         # End
bindkey '\e[2~' beep                   # Insert
bindkey '\e[3~' delete-char            # Del
bindkey '\e[5~' vi-backward-blank-word # Page Up
bindkey '\e[6~' vi-forward-blank-word  # Page Down

bindkey '\ed' delete-char

# normal C-R, C-F and C-S or history search
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey -M viins '^s' history-incremental-search-forward
bindkey -M vicmd '^s' history-incremental-search-forward
bindkey -M viins '^f' history-incremental-pattern-search-backward
bindkey -M vicmd '^f' history-incremental-pattern-search-backward

# go back in menu completion
bindkey -M viins '\e[Z' reverse-menu-complete

# control+u erase entire line on vicmd
bindkey -M viins '^u' kill-whole-line # dd can be used also

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
alias lla="ls -Alh --color=auto"
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
alias task='nocorrect task'
alias find='noglob find'
alias sz='source ~/.zshrc'
alias ez="$EDITOR ~/.zshrc"
alias latex="latex -interaction nonstop"
alias pdflatex="latex -interactiona nonstop"

# suffix
alias -s html=$BROWSER
alias -s png='viewnior'
alias -s jpg='viewnior'
alias -s gif='viewnior'
alias -s txt=$EDITOR
alias -s pdf='zathura'

# RVM setup
[[ -s "/home/ivan/.rvm/scripts/rvm" ]] && source "/home/ivan/.rvm/scripts/rvm"

# fix escape sequences when zsh is loaded with emacs' M-x shell
if [[ $EMACS == 't' ]]; then
    unsetopt zle
fi
