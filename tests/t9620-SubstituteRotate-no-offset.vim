" Test error when no offset or shift value is passed.

call vimtest#StartTap()
call vimtap#Plan(2)

edit enumeration.txt
call vimtap#err#Errors('Missing [/{shift-value}]/[+-]N/', '%SubstituteRotate /doesNotExist/', 'Missing shift value / offset error shown')
call vimtap#err#Errors('Missing [/{shift-value}]/[+-]N/', '%SubstituteRotate /doesNotExist//', 'Missing shift value / offset error shown')

call vimtest#Quit()
