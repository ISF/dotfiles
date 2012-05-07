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

## configuring scripts
# don't print python stack trace
set python print-stack

# enabling script type detection
set script-extension strict
