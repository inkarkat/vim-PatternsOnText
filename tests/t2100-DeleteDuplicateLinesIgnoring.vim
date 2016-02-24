" Test deleting duplicate lines in the entire buffer.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
2
DeleteDuplicateLinesIgnoring
call vimtap#Is(getpos('.'), [0, 8, 1, 0], 'cursor after last deleted line')

call vimtest#SaveOut()
call vimtest#Quit()
