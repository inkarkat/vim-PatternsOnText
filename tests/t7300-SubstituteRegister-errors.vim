" Test error on invalid register pairs.

call vimtest#StartTap()
call vimtap#Plan(3)

edit text.txt
call vimtap#err#Errors('No patterns', '%SubstituteRegister', 'No patterns error shown due to no previous expression')
call vimtap#err#Errors('Not a {pattern-register}={replacement-register} pair: x', '%SubstituteRegister x', 'Register pair syntax error shown due to single register')
call vimtap#err#Errors('No patterns', '%SubstituteRegister g', 'No patterns error shown due to empty expression result')

call vimtest#Quit()
