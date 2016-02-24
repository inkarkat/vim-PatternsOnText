" Test error message when no duplicates of the current line found.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
1
call vimtap#err#Errors('No duplicate lines', 'PrintDuplicateLinesOf', 'error shown')

call vimtest#Quit()
