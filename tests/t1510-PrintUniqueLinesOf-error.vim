" Test error message when no unique of the pattern found.

call vimtest#StartTap()
call vimtap#Plan(2)

edit duplicateLines.txt
call vimtap#err#ErrorsLike('^E471:.*PrintUniqueLinesOf', 'PrintUniqueLinesOf', 'argument error shown')
call vimtap#err#Errors('No unique lines', 'PrintUniqueLinesOf bar', 'error shown')

call vimtest#Quit()
