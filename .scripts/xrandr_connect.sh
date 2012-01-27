#!/bin/bash

size=$(echo $(xrandr -q | grep VGA -A1 | tail -n 1) | cut -d " " -f 1)
xrandr --output LVDS1 --mode 1280x800 --pos 72x${size/*x/} --rotate normal \
       --output VGA1 --mode $size --pos 0x0 --rotate normal
