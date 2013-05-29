" Test error when the outer pattern doesn't match.

edit text.txt
let @/ = 'doesNotExist'
%SubstituteInSearch/x/O/g

call vimtest#Quit()
