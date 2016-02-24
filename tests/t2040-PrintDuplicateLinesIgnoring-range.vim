" Test printing duplicate lines in the passed range.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
2
echomsg 'start'
5,$PrintDuplicateLinesIgnoring
echomsg 'end'
call vimtap#Is(getpos('.'), [0, 11, 1, 0], 'cursor at last duplicate line')

call vimtest#Quit()
