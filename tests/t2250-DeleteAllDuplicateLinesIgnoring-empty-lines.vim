" Test deleting all duplicate lines including empty lines.

edit duplicateAndEmptyLines.txt
12,$DeleteAllDuplicateLinesIgnoring
1,10DeleteAllDuplicateLinesIgnoring ^$

call vimtest#SaveOut()
call vimtest#Quit()
