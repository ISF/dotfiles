## Setting default gdb configurations

# stop printing string in the \0
set print null-stop on

# print a array in only one line
set print array off

# doesn't print the array indexes
set print array-index off

# prints the address a pointer refers to
set print address on

# pretty printing for C structs and unions
set print pretty on
set print union on

# don't print python stack trace
set python print-stack none

# enabling script type detection
set script-extension strict

# print inferior events notification
set print inferior-events on

# auto load gdb scripts
set auto-load python-scripts on
set auto-load local-gdbinit on
set auto-load gdb-scripts on

# auto load go helper
add-auto-load-safe-path /usr/lib/go/src/pkg/runtime/runtime-gdb.py

# follow parents when forking
set follow-fork-mode parent

# makes all exec'ed processes to be a new inferior
set follow-exec-mode new

# all forked processes should be controlled by gdb
set detach-on-fork off

set target-async on
set non-stop on
set pagination off

# use an extended prompt, the trailing whitespace is needed
set extended-prompt \[\e[1;32m\]\w\[\e[0m\]\n\[\e[0;32m\]frame\[\e[0m\] \[\e[0;34m\]\f\[\e[0m\] \n\[\e[0;32m\]thread\]\[\e[0m\] \[\e[0;34m\]\t\[\e[0m\]\n\[\e[0;31m\]>>\[\e[0m\] 
