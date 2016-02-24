" Test reuse of pattern, replacement, flags, and answers when repeating substitution.

edit text.txt
1SubstituteSelected/\<...\>/XXX/g yn
3SubstituteSelected

call vimtest#SaveOut()
call vimtest#Quit()
