" Test passing invalid pair.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#Errors('Not a substitution: no-pair', '%SubstituteWildcard FOO=BAR no-pair', 'error shown')

call vimtest#Quit()
