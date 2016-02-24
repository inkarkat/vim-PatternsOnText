" Test printing duplicate lines including empty lines.

edit duplicateAndEmptyLines.txt
1
echomsg 'start'
1,10PrintDuplicateLinesIgnoring ^\cb..$
echomsg 'end'
echomsg 'start'
12,$PrintDuplicateLinesIgnoring ^$
echomsg 'end'

call vimtest#Quit()
