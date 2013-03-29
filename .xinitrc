#!/bin/bash

xrdb -merge .Xresources
xset +fp /usr/share/fonts/local
xset fp rehash
setxkbmap br
xsetroot -cursor_name left_ptr
nitrogen --restore
unclutter &
urxvtd -q -f -o
mpd
xmodmap .Xmodmap
xbindkeys
if [[ -z $(pgrep -l synergy) && $(hostname) == "hadouken" ]]; then
    (synergyc shungokusatsu &);
fi
/home/ivan/.scripts/dzenconky.sh
exec dbus-launch xmonad
