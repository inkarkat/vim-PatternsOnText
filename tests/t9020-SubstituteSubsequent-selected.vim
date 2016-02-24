" Test replacing selected instances after the cursor.

edit duplicates.txt

" Tests within the current line.
7normal! 6W
SubstituteSubsequent/\<...\>/XXX/g yn

" Tests within the remainder of the buffer.
9normal! 3W
.,$SubstituteSubsequent/\<...\>/YYY/g yn

" Tests non-global once per line replacement.
1normal! W
%SubstituteSubsequent/E /. /yny

call vimtest#SaveOut()
call vimtest#Quit()
