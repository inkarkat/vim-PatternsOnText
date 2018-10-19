" Test deleting duplicate lines without not passed pattern in the entire buffer.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
2
DeleteDuplicateLinesIgnoring! ^\cb..$
call vimtap#Is(getpos('.'), [0, 9, 1, 0], 'cursor after last deleted line')

call vimtest#SaveOut()
call vimtest#Quit()
