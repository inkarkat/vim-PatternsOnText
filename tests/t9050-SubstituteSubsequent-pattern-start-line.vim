" Test replacing instances after the cursor anchored to the start of the line.

edit duplicates.txt
7normal! 6W
.,$SubstituteSubsequent/^E/./g

call vimtest#SaveOut()
call vimtest#Quit()
