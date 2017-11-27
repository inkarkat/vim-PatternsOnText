" Test printing duplicates of not passed pattern found in the entire buffer.

edit duplicateLines.txt
1
echomsg 'start'
PrintDuplicateLinesOf! ^\cb..$
echomsg 'end'

call vimtest#Quit()
