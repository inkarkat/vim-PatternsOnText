" Test deleting all duplicate lines in the entire buffer.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
2
DeleteAllDuplicateLinesIgnoring
call vimtap#Is(getpos('.'), [0, 5, 1, 0], 'cursor after last deleted line')

call vimtest#SaveOut()
call vimtest#Quit()
