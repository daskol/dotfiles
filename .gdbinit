#   .gdbinit
#
#   See for details https://github.com/gdbinit/Gdbinit

set history filename ~/.gdb_history
set history save

set extended-prompt \[\e[1;37m\](gdb) \[\e[0m\]

define threads
    info threads
end
document threads
Syntax: threads
| Print threads in target.
end

source ~/.gdb/gdb-colour-filter/colour_filter.py
