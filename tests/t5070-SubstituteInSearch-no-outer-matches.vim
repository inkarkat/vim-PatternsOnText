" Test error when the outer pattern doesn't match.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
let @/ = 'doesNotExist'
call vimtap#err#Errors('E486: Pattern not found: doesNotExist', '%SubstituteInSearch/x/O/g', 'error shown')

call vimtest#Quit()
