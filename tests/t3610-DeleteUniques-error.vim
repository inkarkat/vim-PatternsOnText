" Test error message when no unique lines in the entire buffer.

set report=1
call vimtest#StartTap()
call vimtap#Plan(1)

call setline(1, 'foo')
call setline(2, 'foo')
call vimtap#err#Errors('No unique matches', '%DeleteUniques \<\w\+\>', 'error shown')

call vimtest#SaveOut()
call vimtest#Quit()
