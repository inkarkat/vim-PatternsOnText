" Test substituting with flags for the outer search.

edit text.txt
let @/ = '\<f..\>'
1SubstituteInSearch/o/X/
3SubstituteInSearch/o/X/gi

call vimtest#SaveOut()
call vimtest#Quit()
