" Test printing duplicates of the current line found in the entire buffer.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
2
echomsg 'start'
PrintDuplicateLinesOf
echomsg 'end'
call vimtap#Is(getpos('.'), [0, 10, 1, 0], 'cursor at last duplicate line')

call vimtest#Quit()
