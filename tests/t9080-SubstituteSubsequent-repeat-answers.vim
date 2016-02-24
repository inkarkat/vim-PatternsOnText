" Test reuse of pattern, replacement, and flags, but new answers when repeating substitution.

edit duplicates.txt

" Tests within the current line.
7normal! 6W
SubstituteSubsequent/\<...\>/XXX/g yn

" Tests within the remainder of the buffer.
9normal! 3W
.,$SubstituteSubsequent nyy

call vimtest#SaveOut()
call vimtest#Quit()
