" Test substituting with the previous search.

call setline(1, 'my foo#bar is do#ne in he#re for th#at')
let @/ = '\w#\w'
SubstituteNotInSearch@[io]@X@g

call vimtest#SaveOut()
call vimtest#Quit()

