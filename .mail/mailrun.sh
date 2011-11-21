#!/bin/bash

PID=$(pgrep offlineimap)

# if it is still running then stop it
[[ -n "$PID" ]] && kill $PID

offlineimap -o -u quiet &>/dev/null &
sed -i 's/"+spam"\|"+trash"\|"+sent"//' /home/ivan/.mutt/muttrc.mailboxes
goobook reload

exit 0
