" Test reuse of pattern, replacement, flags, and predicate when repeating substitution.

edit text.txt
1SubstituteIf /foo/BAR/g col('.') % 2
3SubstituteIf

call vimtest#SaveOut()
call vimtest#Quit()
