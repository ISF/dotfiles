#!/bin/bash

# Extract a mailing list address from a message

HEADER="List-Post"

grep $HEADER - | egrep -o "\<mailto:.*\>" | cut -d ":" -f 2 >> ~/.mutt/lists.muttrc
