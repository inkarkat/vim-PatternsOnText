" Test substituting with flags for the outer search.

edit text.txt
let @/ = '\<f..\>'
1SubstituteNotInSearch/./X/
3SubstituteNotInSearch/o/X/gi

call vimtest#SaveOut()
call vimtest#Quit()
