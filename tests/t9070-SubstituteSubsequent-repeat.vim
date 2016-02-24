" Test reuse of pattern, replacement, flags, and answers when repeating substitution.

edit duplicates.txt

" Tests within the current line.
7normal! 6W
SubstituteSubsequent/\<...\>/XXX/g yn

" Tests within the remainder of the buffer.
9normal! 3W
.,$SubstituteSubsequent

call vimtest#SaveOut()
call vimtest#Quit()
