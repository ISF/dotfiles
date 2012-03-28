#!/bin/sh
 
FG='white'
BG='#121212'
FONT='-*-terminus-*-*-*-*-12-*-*-*-*-*-iso8859-*'
conky -c $HOME/.conky_dzen_$(hostname) | dzen2 -e - -x '840' -ta r -fg $FG -bg $BG -fn $FONT &
