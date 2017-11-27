" Test deleting all duplicate lines in the entire buffer.
" Tests that [!] is without effect when there's no /{pattern}/

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicateLines.txt
2
DeleteAllDuplicateLinesIgnoring!
call vimtap#Is(getpos('.'), [0, 5, 1, 0], 'cursor after last deleted line')

call vimtest#SaveOut()
call vimtest#Quit()
