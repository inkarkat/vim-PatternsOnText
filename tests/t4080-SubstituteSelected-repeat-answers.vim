" Test reuse of pattern, replacement, and flags, but new answers when repeating substitution.

edit text.txt
1SubstituteSelected/\<...\>/XXX/g yn
3SubstituteSelected nyy

call vimtest#SaveOut()
call vimtest#Quit()
