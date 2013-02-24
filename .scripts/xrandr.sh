#!/bin/bash

size=$(echo $(xrandr -q | grep VGA -A1 | tail -n 1) | cut -d " " -f 1)
size_note=$(echo $(xrandr -q | grep LVDS1 -A1 | tail -n 1) | cut -d " " -f 1)

if [[ -z $(xrandr -q | grep VGA | grep disconnected) ]]; then
    if [[ $1 == "extern_only" ]]; then
        xrandr --output LVDS1 --off --output VGA1 --mode $size --pos 0x0 --rotate normal
    else
        xrandr --output LVDS1 --primary --mode $size_note --pos 72x${size/*x/} --rotate normal \
            --output VGA1 --mode $size --pos 0x0 --rotate normal
    fi
else
    xrandr --output LVDS1 --mode $size_note --pos 0x0 --rotate normal --output VGA1 --off
fi
nitrogen --restore
pkill conky # ugly, but works
dzenconky.sh
setxkbmap br
xmodmap ~/.Xmodmap
