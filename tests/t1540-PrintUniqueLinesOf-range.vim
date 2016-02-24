" Test printing uniques found in the passed range.
" Tests that the current line, not the start of the range is used.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
2
echomsg 'start'
4,$-1PrintUniqueLinesOf .*
echomsg 'end'
call vimtap#Is(getpos('.'), [0, 8, 1, 0], 'cursor at last unique line')

call vimtest#Quit()
