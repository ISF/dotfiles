################################################################################
# Options
################################################################################

shopt -s histappend # append history file instead of rewriting
history -a # keeping the same history on all sessions
shopt -s extglob # better shell expansion capability
ulimit -c unlimited

################################################################################
# Variables
################################################################################

# Setting CFLAGS and CXXFLAGS if none of them are already defined
if [[ -z $CFLAGS ]]; then
	export CFLAGS="-march=core2 -O2 -pipe"
fi

if [[ -z $CXXFLAGS ]]; then
	CXXFLAGS="$CFLAGS"
fi

# Colorful PS1 variable taken from gentoo's bashrc
if [[ ${EUID} == 0 ]] ; then
	PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
	PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

export EDITOR=$(which vim)
export BROWSER=chromium
export PAGER=$(which most)
export TERM=xterm-256color


################################################################################
# Alias
################################################################################
alias ls="ls --color=auto"
alias pacman_tips='echo "pacman -Syu       # Synchronize with repositories before upgrading packages that are out of date on the local system.
pacman -S         # Install specific package(s) from the repositories
pacman -Up        # Install specific package not from the repositories as a file
pacman -R         # Remove the specified package(s), retaining its configuration(s) and required dependencies
pacman -Rns       # Remove the specified package(s), its configuration(s) and unneeded dependencies
pacman -Si        # Display information about a given package in the repositories
pacman -Ss        # Search for package(s) in the repositories
pacman -Scc       # Clean cache
pacman -Qi        # Display information about a given package in the local database
pacman -Qmq		  # Display foreign (aur, abs) packages
pacman -Qs        # Search for package(s) in the local database"'
alias disk-record='echo "growisofs -Z /dev/dvd -allow-limited-size -speed=4 -R -J <arquivos>";echo "cdrecord -v -dev=/dev/scd0 speed=16 <iso>"'
alias oka='echo valeu'
alias bandeco='links -dump http://www.prefeitura.unicamp.br/servicos.php?servID=119 | head -n 23 | tail -n 14 | sed "s/.\{0,35\}[ ]*//" | grep -v ^$ | sed -e "s/\//./g"'
alias mk_vimcfg="tar cJvf vim_config-$(date +%F | sed 's/-//g').tar.xz ~/.vim --exclude ~/.vim/undodir"
alias mk_weecfg="tar cJvf weechat_config-$(date +%F | sed 's/-//g').tar.xz ~/.weechat --exclude ~/.weechat/logs"
alias mk_opbcfg="tar cJvf openbox_config-$(date +%F | sed 's/-//g').tar.xz ~/.config/openbox"
alias mk_muttcfg="tar cJvf mutt_config-$(date +%F | sed 's/-//g').tar.xz ~/.mutt --exclude ~/.mutt/cache"
alias beye='TERM=xterm biew'
alias info='info --vi-keys'
alias less='less -R'
alias callgrind='valgrind --tool=callgrind'
alias tmux='tmux -2'

################################################################################
# Misc
################################################################################

# starting ssh-agent
if [[ -z $(pidof ssh-agent) ]]; then
	eval $(ssh-agent)
fi

# starting gpg-agent
envfile="${HOME}/.gnupg/gpg-agent.env"
if test -f "$envfile" && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
	eval "$(cat "$envfile")"
else
	eval "$(gpg-agent --daemon --write-env-file "$envfile")"
fi
export GPG_AGENT_INFO

# Using vim as a manpage reader
#export PAGER="/usr/bin/vimpager"
#alias less=$PAGER

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
