" Test replacing instances after the cursor column in all following lines.

edit duplicates.txt
7normal! 3W
.,$SubstituteSubsequent/\<...\>/XXX/gb

call vimtest#SaveOut()
call vimtest#Quit()
