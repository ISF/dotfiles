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
