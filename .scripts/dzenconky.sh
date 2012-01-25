#!/bin/sh
 
FG='white'
BG='#121212'
FONT='-*-terminus-*-*-*-*-12-*-*-*-*-*-iso8859-*'
conky -c .conky_dzen | dzen2 -e - -x '840' -w '550' -ta r -fg $FG -bg $BG -fn $FONT &
