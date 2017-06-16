" Test reuse of pattern, replacement, flags, and predicate when repeating substitution with negated one.

edit text.txt
1SubstituteIf /foo/BAR/g col('.') % 2
3SubstituteUnless

call vimtest#SaveOut()
call vimtest#Quit()
