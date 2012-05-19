#!/bin/sh

size=$(echo $(xrandr -q | grep VGA -A1 | tail -n 1) | cut -d " " -f 1)
xrandr --output LVDS1 --off --output VGA1 --mode $size --pos 0x0 --rotate normal
