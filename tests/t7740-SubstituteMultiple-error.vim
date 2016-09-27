" Test error when less than two replacements are given.

call vimtest#StartTap()
call vimtap#Plan(2)

call vimtap#err#Errors('No replacement given', 'SubstituteChoices/foo//g', 'error shown')
call vimtap#err#Errors('Only one replacement given', 'SubstituteChoices/foo/bar/g', 'error shown')
call vimtest#Quit()
