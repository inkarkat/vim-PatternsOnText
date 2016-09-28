" Test missing expression.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(3)

call vimtap#err#Errors('Missing expression', '1SubstituteExecute', 'error shown')
call vimtap#err#Errors('Missing expression', '1SubstituteExecute /foo/', 'error shown')
call vimtap#err#Errors('Missing expression', '1SubstituteExecute /foo/g', 'error shown')

call vimtest#SaveOut()
call vimtest#Quit()
