" Test printing duplicate lines without passed pattern in the entire buffer.
" Tests that the line isn't printed again as a header when there's only one particular line with duplicates.

edit duplicateLines.txt
1
echomsg 'start'
PrintDuplicateLinesIgnoring ^\cb..$
echomsg 'end'

call vimtest#Quit()
