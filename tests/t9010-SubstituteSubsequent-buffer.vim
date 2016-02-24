" Test replacing instances after the cursor in the remainder of the buffer.

edit duplicates.txt
7normal! 6W
.,$SubstituteSubsequent/\<...\>/XXX/g

call vimtest#SaveOut()
call vimtest#Quit()
