" Test when the outer pattern matches everywhere.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
let @/ = '.*'
call vimtap#err#ErrorsLike('Pattern not found: .\+\.\*', '%SubstituteNotInSearch/\w/X/g', 'error shown')

call vimtest#Quit()
