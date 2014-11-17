" Test printing duplicates of the current line found in the passed buffer.
" Tests that the current line, not the start of the range is used.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
2
echomsg 'start'
4,$PrintDuplicateLinesOf
echomsg 'end'
call vimtap#Is(getpos('.'), [0, 10, 1, 0], 'cursor at last duplicate line')

call vimtest#Quit()
