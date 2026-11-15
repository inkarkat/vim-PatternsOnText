" Test error on invalid register pairs.

call vimtest#StartTap()
call vimtap#Plan(3)

edit text.txt
call vimtap#err#Errors('No registers', '%SubstituteRegister', 'No registers error shown due to no previous expression')
call vimtap#err#Errors('No registers', '%SubstituteRegister g', 'No registers error shown with passed flag due to no previous expression')
call vimtap#err#Errors('Not a {pattern-register}={replacement-register} pair: x', '%SubstituteRegister x', 'Register pair syntax error shown due to single register')

call vimtest#Quit()
