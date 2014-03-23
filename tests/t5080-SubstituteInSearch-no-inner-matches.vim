" Test error when the inner pattern doesn't match.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
let @/ = '\<...\>'
try
    %SubstituteInSearch/doesNotExist/XXX/g
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Pattern not found: doesNotExist', 'error shown')
endtry

call vimtest#Quit()
