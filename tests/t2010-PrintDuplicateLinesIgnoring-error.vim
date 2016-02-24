" Test error message when no duplicate lines in the entire buffer.

call vimtest#StartTap()
call vimtap#Plan(1)

call setline(1, 'foo')
call setline(2, 'bar')
1
call vimtap#err#Errors('No duplicate lines', 'PrintDuplicateLinesIgnoring', 'error shown')

call vimtest#Quit()
