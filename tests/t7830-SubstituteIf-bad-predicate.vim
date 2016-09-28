" Test invalid predicate.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#Errors('E121: Undefined variable: isnotvalid', '%SubstituteIf /foo/BAR/g isnotvalid)*#expr', 'error shown')

call vimtest#SaveOut()
call vimtest#Quit()
