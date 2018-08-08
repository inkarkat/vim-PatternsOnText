" Test missing expression.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(2)
call vimtap#err#Errors('Missing {expr}/{func}/{item1}...', '%SubstituteTranslate /\<...\>//g', 'error shown')
call vimtap#err#Errors('Missing {expr}/{func}/{item1}...', '%SubstituteTranslate /\<...\>/\=/g', 'error shown')

call vimtest#SaveOut()
call vimtest#Quit()
