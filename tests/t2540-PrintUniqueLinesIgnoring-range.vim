" Test printing unique lines in the passed range.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
2
echomsg 'start'
5,$-1PrintUniqueLinesIgnoring
echomsg 'end'
call vimtap#Is(getpos('.'), [0, 8, 1, 0], 'cursor at last unique line')

call vimtest#Quit()
