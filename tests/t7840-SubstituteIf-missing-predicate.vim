" Test missing predicate.

edit text.txt
call vimtest#StartTap()
call vimtap#Plan(3)

call vimtap#err#Errors('Missing predicate', '1SubstituteIf', 'error shown')
call vimtap#err#Errors('Missing predicate', '1SubstituteIf /foo/BAR/', 'error shown')
call vimtap#err#Errors('Missing predicate', '1SubstituteIf /foo/BAR/g', 'error shown')

call vimtest#SaveOut()
call vimtest#Quit()
