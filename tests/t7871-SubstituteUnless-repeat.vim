" Test reuse of pattern, replacement, flags, and predicate when repeating negated substitution.

edit text.txt
1SubstituteUnless /foo/BAR/g col('.') % 2
3SubstituteUnless

call vimtest#SaveOut()
call vimtest#Quit()
