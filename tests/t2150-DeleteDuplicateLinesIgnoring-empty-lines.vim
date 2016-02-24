" Test deleting duplicate lines including empty lines.

edit duplicateAndEmptyLines.txt
12,$DeleteDuplicateLinesIgnoring ^$
1,10DeleteDuplicateLinesIgnoring ^\cb..$

call vimtest#SaveOut()
call vimtest#Quit()
