" Test substituting in the buffer with inline search pattern and flags.

edit text.txt
let @/ = 'unrelated'
1SubstituteNotInSearch/\<f..\>/o/X/gf
3SubstituteNotInSearch/\<f..\>/o/X/gi

call vimtest#SaveOut()
call vimtest#Quit()
