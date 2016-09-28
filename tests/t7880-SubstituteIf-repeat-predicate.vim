" Test reuse of pattern, replacement, flags, but new predicate when repeating substitution.

edit text.txt
1SubstituteIf /foo/BAR/g col('.') % 2
3SubstituteIf col('.') % 2 == 0

call vimtest#SaveOut()
call vimtest#Quit()
