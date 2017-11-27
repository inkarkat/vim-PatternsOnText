" Test deleting duplicates of not the current line found in the entire buffer.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
2
DeleteDuplicateLinesOf!
call vimtap#Is(getpos('.'), [0, 10, 1, 0], 'cursor after last deleted line')

call vimtest#SaveOut()
call vimtest#Quit()
