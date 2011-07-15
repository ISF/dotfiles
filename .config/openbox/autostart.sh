# This shell script is run before Openbox launches.
# Environment variables set here are passed to the Openbox session.


########## Start of default settings ###########

# D-bus
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
       eval `dbus-launch --sh-syntax --exit-with-session`
fi

# Run XDG autostart things.  By default don't run anything desktop-specific
# See xdg-autostart --help more info
DESKTOP_ENV="OPENBOX"
if which /usr/lib64/openbox/xdg-autostart >/dev/null; then
  /usr/lib64/openbox/xdg-autostart $DESKTOP_ENV
fi

############# End default settings ###############

############ Start of custom settings ############

# starting ssh-agent
eval $(ssh-agent)

# setting correct keymap
setxkbmap br &

# activating numlock key
numlockx on &

# fixing fn keys
xmodmap /home/ivan/.config/openbox/keys

# starting ssh-agent
if [[ -z $(pidof ssh-agent) ]]; then
    eval $(ssh-agent)
fi

# starting gpg-agent
envfile="${HOME}/.gnupg/gpg-agent.env"
if test -f "$envfile" && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
    eval "$(cat "$envfile")"
else
    eval "$(gpg-agent --daemon --write-env-file "$envfile")"
fi
export GPG_AGENT_INFO

sleep 2 # ensure that the next applications start after openbox

cairo-compmgr &

# starting terminal
if [[ -z $(pidof terminal) ]]; then
    terminal --hide-menubar &
fi

# starting conky, use ~/.conkyrc as a link to the correct conky configuration
if [[ -n $DISPLAY && -z $(pidof conky) ]]; then
    conky -d
    conky -c /home/ivan/.conkyrc_cal -d
fi

# wallpaper with feh
WALLPAPER_PATH=/home/ivan/images/wallpaper
feh --bg-scale $WALLPAPER_PATH

wicd-gtk &

kupfer --no-splash &

volumeicon &

neap &

sleep 3 && tint2 &
