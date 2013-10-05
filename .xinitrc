#!/bin/bash

xrdb -merge .Xresources
xset +fp /usr/share/fonts/local
xset fp rehash
xsetroot -cursor_name left_ptr
nitrogen --restore
unclutter &
urxvtd -q -f -o
mpd
setxkbmap -layout br,ru
xmodmap .Xmodmap
xbindkeys
pulseaudio --start
if [[ -z $(pgrep -l synergy) && $(hostname) == "hadouken" ]]; then
    (synergyc shungokusatsu &);
fi
/home/ivan/.scripts/dzenconky.sh
exec dbus-launch xmonad
