" Test error message when no duplicate lines in the entire buffer.

call vimtest#StartTap()
call vimtap#Plan(1)

call setline(1, 'foo')
call setline(2, 'bar')
1
try
    PrintDuplicateLinesIgnoring
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No duplicate lines', 'error shown')
endtry

call vimtest#Quit()
