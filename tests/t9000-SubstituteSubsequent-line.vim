" Test replacing instances after the cursor in a single line.

edit duplicates.txt
7normal! 6W
SubstituteSubsequent/\<...\>/XXX/g
9normal! 3W
SubstituteSubsequent/\<...\>/YYY/

call vimtest#SaveOut()
call vimtest#Quit()
