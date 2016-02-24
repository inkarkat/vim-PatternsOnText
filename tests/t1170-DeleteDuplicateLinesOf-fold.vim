" Test deleting duplicates of the current line found in the fold.

edit duplicateLines.txt
7,11fold
2
7DeleteDuplicateLinesOf

call vimtest#SaveOut()
call vimtest#Quit()
