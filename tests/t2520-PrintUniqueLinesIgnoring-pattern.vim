" Test printing unique lines without passed pattern in the entire buffer.

edit duplicateLines.txt
1
echomsg 'start'
PrintUniqueLinesIgnoring eof
echomsg 'end'

call vimtest#Quit()
