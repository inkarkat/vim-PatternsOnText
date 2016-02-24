" Test printing unique lines in the entire buffer.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
2
echomsg 'start'
PrintUniqueLinesIgnoring
echomsg 'end'
call vimtap#Is(getpos('.'), [0, 12, 1, 0], 'cursor at last unique line')

call vimtest#Quit()
