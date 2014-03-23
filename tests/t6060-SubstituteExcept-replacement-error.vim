" Test syntax error in special replacement.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#Errors("E110: Missing ')'", '1SubstituteExcept/\<...\>/\=string((((submatch(1)/', 'error shown')

call vimtest#SaveOut()
call vimtest#Quit()
