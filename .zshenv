LANG=pt_BR.UTF8

#### Daemons

# ssh-agent
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

#### Variables

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

# RVM setup
[[ -s "/home/ivan/.rvm/scripts/rvm" ]] && source "/home/ivan/.rvm/scripts/rvm"

source ~/.zshrc
