" Test error message when no duplicate lines in the entire buffer.

set report=1
call vimtest#StartTap()
call vimtap#Plan(1)

call setline(1, 'foo')
call setline(2, 'bar')
call vimtap#err#Errors('No duplicates', '%DeleteAllDuplicates \<\w\+\>', 'error shown')

call vimtest#SaveOut()
call vimtest#Quit()
