" Test deleting unique lines in the entire buffer.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
2
DeleteUniqueLinesIgnoring
call vimtap#Is(getpos('.'), [0, 7, 1, 0], 'cursor after last deleted line')

call vimtest#SaveOut()
call vimtest#Quit()
