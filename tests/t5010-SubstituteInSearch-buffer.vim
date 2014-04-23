" Test substituting in the buffer.

edit text.txt
let @/ = '\<...\>'
%SubstituteInSearch/o/X/g

call vimtest#SaveOut()
call vimtest#Quit()
