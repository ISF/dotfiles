#!/bin/bash

if [[ $1 == "extern_only" ]]; then
    cmd="$HOME/.scripts/extern_only.sh"
else
    cmd="$HOME/.scripts/xrandr_connect.sh"
fi


if [[ -z $(xrandr -q | grep VGA | grep disconnected) ]]; then
    $cmd
else
    $HOME/.scripts/xrandr_disconnect.sh
fi
nitrogen --restore
pkill conky # ugly, but works
dzenconky.sh
setxkbmap br
xmodmap ~/.Xmodmap
