" Test replacing with negated predicate in a line.

edit text.txt
1
SubstituteUnless /foo/BAR/g col('.') % 2

call vimtest#SaveOut()
call vimtest#Quit()
