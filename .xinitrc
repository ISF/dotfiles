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

case $1 in
    openbox)
        exec ck-launch-session dbus-launch openbox-session;;
    xmonad)
        exec ck-launch-session dbus-launch xmonad;;
    *)
        exec ck-launch-session dbus-launch xmonad;;
esac
