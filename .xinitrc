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
numlockx on &
xmodmap .Xmodmap
xbindkeys
/home/ivan/.scripts/dzenconky.sh
xfce4-power-manager &
exec ck-launch-session dbus-launch xmonad
