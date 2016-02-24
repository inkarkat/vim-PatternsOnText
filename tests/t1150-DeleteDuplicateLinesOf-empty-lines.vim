" Test deleting duplicates including empty lines.

edit duplicateAndEmptyLines.txt
12,$DeleteDuplicateLinesOf ^\%(\cb..\)\?$
1,10DeleteDuplicateLinesOf ^spaz$

call vimtest#SaveOut()
call vimtest#Quit()
