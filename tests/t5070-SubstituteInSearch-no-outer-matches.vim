" Test error when the outer pattern doesn't match.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
let @/ = 'doesNotExist'
try
    %SubstituteInSearch/x/O/g
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('E486: Pattern not found: doesNotExist', 'error shown')
endtry

call vimtest#Quit()
