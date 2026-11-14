" Test error when the register doesn't match.

call vimtest#StartTap()
call vimtap#Plan(1)

let @a = 'doesNotExist'
let @b = 'XXX'
edit text.txt
call vimtap#err#ErrorsLike('^E486: .*: \\(doesNotExist\\)', '%SubstituteRegister a=b', 'Pattern not found error shown')

call vimtest#Quit()
