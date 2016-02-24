" Test substituting in a single line.

edit text.txt
let @/ = '\<...\>'
1
SubstituteInSearch/o/X/g

call vimtest#SaveOut()
call vimtest#Quit()
