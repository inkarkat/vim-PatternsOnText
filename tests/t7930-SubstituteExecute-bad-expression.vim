" Test replacing with invalid expression.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#Errors('E492: Not an editor command: doesnotevaluate)*#statement', '%SubstituteExecute /foo/g doesnotevaluate)*#statement', 'error shown')

call vimtest#SaveOut()
call vimtest#Quit()
