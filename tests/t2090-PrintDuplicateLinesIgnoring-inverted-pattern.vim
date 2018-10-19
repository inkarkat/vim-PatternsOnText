" Test printing duplicate lines without not passed pattern in the entire buffer.

edit duplicateLines.txt
1
echomsg 'start'
PrintDuplicateLinesIgnoring! ^\cb..$
echomsg 'end'

call vimtest#Quit()
