" Test substituting in the buffer with inline search pattern and flags.

edit text.txt
let @/ = 'unrelated'
1SubstituteInSearch/\<f..\>/o/X/gf
3SubstituteInSearch/\<f..\>/o/X/gi

call vimtest#SaveOut()
call vimtest#Quit()
