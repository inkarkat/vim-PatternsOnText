" Test replacing with invalid expression.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#err#Errors('E121: Undefined variable: doesnotevaluate', '%SubstituteTranslate /\<...\>/\=doesnotevaluate/g', 'error shown')

call vimtest#SaveOut()
call vimtest#Quit()
