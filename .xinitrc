#!/bin/bash

#xrandr --setprovideroutputsource modesetting NVIDIA-0
#xrandr --auto
xrdb -merge .Xresources
xset +fp /usr/share/fonts/local
xset fp rehash
xsetroot -cursor_name left_ptr
nitrogen --restore
unclutter &
urxvtd -q -f -o
mpd
#setxkbmap -option grp:alt_space_toggle -layout br,ru
setxkbmap -layout br
xbindkeys
pulseaudio  --start
xmodmap /home/ivan/.Xmodmap
/home/ivan/.scripts/dzenconky.sh
exec dbus-launch xmonad
