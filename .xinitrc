#!/bin/bash

xset +fp /usr/share/fonts/local
xset fp rehash
xsetroot -cursor_name left_ptr
hsetroot -solid '#000000'
dunst &
unclutter &
xinput disable "ETPS/2 Elantech Touchpad"
pulseaudio --start
#compton -b --backend glx --vsync opengl --paint-on-overlay
exec i3
