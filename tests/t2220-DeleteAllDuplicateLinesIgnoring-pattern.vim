" Test deleting all duplicate lines without passed pattern in the entire buffer.

edit duplicateLines.txt
1
DeleteAllDuplicateLinesIgnoring ^\cb..$

call vimtest#SaveOut()
call vimtest#Quit()
