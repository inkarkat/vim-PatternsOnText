" Test substituting in the buffer with inline search pattern.

edit text.txt
let @/ = 'unrelated'
%SubstituteNotInSearch/\<...\>/o/X/g

call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(@/, 'unrelated', 'last search pattern not modified')

call vimtest#SaveOut()
call vimtest#Quit()
