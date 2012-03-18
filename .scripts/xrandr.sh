#!/bin/bash

if [[ -z $(xrandr -q | grep VGA | grep disconnected) ]]; then
    /home/ivan/.scripts/xrandr_connect.sh
else
    /home/ivan/.scripts/xrandr_disconnect.sh
fi
nitrogen --restore
pkill conky # ugly, but works
dzenconky.sh
