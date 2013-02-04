#!/bin/bash

PID=$(pgrep offlineimap)

# if it is still running then stop it
[[ -n "$PID" ]] && kill $PID

offlineimap -o -u quiet &>/dev/null &
sed -i 's/"+[Gmail]\.Spam"\|"+[Gmail]\.Trash"\|"+[Gmail]\.Sent Mail"//' /home/ivan/.mutt/muttrc.mailboxes
goobook reload
notmuch new

exit 0
