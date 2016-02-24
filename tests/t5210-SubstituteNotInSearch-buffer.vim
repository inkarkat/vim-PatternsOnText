" Test substituting in the buffer.

edit text.txt
let @/ = '\<...\>'
%SubstituteNotInSearch/o/X/g

call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(@/, '\<...\>', 'last search pattern not modified')

call vimtest#SaveOut()
call vimtest#Quit()
