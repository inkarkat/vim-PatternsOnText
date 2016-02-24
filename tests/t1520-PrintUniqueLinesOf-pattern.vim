" Test printing uniques of passed pattern found in the entire buffer.

edit duplicateLines.txt
1
echomsg 'start'
PrintUniqueLinesOf ^...$
echomsg 'end'

call vimtest#Quit()
