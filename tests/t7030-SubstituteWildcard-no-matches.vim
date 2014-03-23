" Test error when the pair doesn't match.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
call vimtap#err#Errors('E486: Pattern not found: \(\VdoesNotExist\)', '%SubstituteWildcard doesNotExist=XXX', 'error shown')

call vimtest#Quit()
