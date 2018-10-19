" Test printing unique lines without not passed pattern in the entire buffer.

edit duplicateLines.txt
1
echomsg 'start'
PrintUniqueLinesIgnoring! /.*oo.*/
echomsg 'end'

call vimtest#Quit()
