xrdb -merge .Xresources
xset +fp /usr/share/fonts/local
xset fp rehash
setxkbmap br
xsetroot -cursor_name left_ptr
nitrogen --restore
unclutter &
urxvtd -q -f -o
dropboxd &
mpd
xmodmap .Xmodmap
xbindkeys
if [[ -z $(pgrep -l synergy) ]]; then (synergyc shungokusatsu &); fi
/home/ivan/.scripts/dzenconky.sh
exec ck-launch-session dbus-launch xmonad
