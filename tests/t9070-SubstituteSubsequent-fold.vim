" Test replacing instances after the cursor in the fold.

edit duplicates.txt
7normal! 5W
7,$fold
.SubstituteSubsequent/\<...\>/XXX/g

call vimtest#SaveOut()
call vimtest#Quit()
