" Test error when the outer pattern doesn't match.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
let @/ = 'doesNotExist'
call vimtap#err#ErrorsLike('^E486: .*: doesNotExist', '%SubstituteInSearch/x/O/g', 'Pattern not found error shown')

call vimtest#Quit()
