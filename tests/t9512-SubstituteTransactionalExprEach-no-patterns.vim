" Test error when no patterns are given.

call vimtest#StartTap()
call vimtap#Plan(2)

edit text.txt
call vimtap#err#Errors('No patterns', '%SubstituteTransactionalExprEach ', 'No patterns error shown due to no previous pattern')
call vimtap#err#Errors('No patterns', '%SubstituteTransactionalExprEach /[]/"foo"/g', 'No patterns error shown due to empty expression result')

call vimtest#Quit()
