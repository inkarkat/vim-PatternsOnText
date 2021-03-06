" Test printing duplicate lines in the entire buffer.
" Tests that [!] is without effect when there's no /{pattern}/

call vimtest#StartTap()
call vimtap#Plan(2)

edit duplicateLines.txt
2
echomsg 'start'
PrintDuplicateLinesIgnoring!
echomsg 'end'
call vimtap#Is(getpos('.'), [0, 11, 1, 0], 'cursor at last duplicate line')
call vimtap#Ok(! &l:modified, 'buffer not modified')

call vimtest#Quit()
