#!/bin/bash

xrdb -merge .Xresources
xset +fp /usr/share/fonts/local
xset fp rehash
xsetroot -cursor_name left_ptr
nitrogen --restore
unclutter &
urxvtd -q -f -o
mpd
setxkbmap -option grp:alt_space_toggle -layout br,ru
xmodmap .Xmodmap
xbindkeys
pulseaudio --start
/home/ivan/.scripts/dzenconky.sh
exec dbus-launch xmonad
