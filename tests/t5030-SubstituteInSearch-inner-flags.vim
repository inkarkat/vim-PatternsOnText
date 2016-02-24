" Test substituting with flags for the inner search.

edit text.txt
let @/ = '\<f..\>'
1SubstituteInSearch/o/X/gf
3SubstituteInSearch/o/X/f

call vimtest#SaveOut()
call vimtest#Quit()
