" Test error message when no unique lines in the entire buffer.

call vimtest#StartTap()
call vimtap#Plan(1)

call setline(1, 'foo')
call setline(2, 'foo')
1
call vimtap#err#Errors('No unique lines', 'PrintUniqueLinesIgnoring', 'error shown')

call vimtest#Quit()
