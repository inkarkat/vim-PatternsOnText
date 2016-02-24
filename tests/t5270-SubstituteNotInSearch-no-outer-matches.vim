" Test when the outer pattern doesn't match.

edit text.txt
let @/ = 'doesNotExist'
%SubstituteNotInSearch/\w/X/g

call vimtest#SaveOut()
call vimtest#Quit()
