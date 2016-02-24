" Test substituting with flags for the inner search.

edit text.txt
let @/ = '\<f..\>'
1SubstituteNotInSearch/o/X/gf
3SubstituteNotInSearch/./X/f

call vimtest#SaveOut()
call vimtest#Quit()
