" Test substituting in the buffer with empty inline search pattern.

edit text.txt
let @/ = '\<...\>'
%SubstituteInSearch//o/X/g

call vimtest#SaveOut()
call vimtest#Quit()
