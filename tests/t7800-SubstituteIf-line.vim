" Test replacing with predicate in a line.

edit text.txt
1
SubstituteIf /foo/BAR/g col('.') % 2

call vimtest#SaveOut()
call vimtest#Quit()
