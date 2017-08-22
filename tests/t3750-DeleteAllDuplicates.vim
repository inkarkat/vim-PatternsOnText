" Test deleting all duplicates in the current line.

set report=1
call vimtest#StartTap()
call vimtap#Plan(2)

edit duplicates.txt
7DeleteAllDuplicates \<\w\+\>
call vimtap#Is(getpos('.'), [0, 7, 1, 0], 'cursor on last line with deletions')
9DeleteAllDuplicates \s*\<\w\+\>
call vimtap#Is(getpos('.'), [0, 9, 1, 0], 'cursor on last line with deletions')

call vimtest#SaveOut()
call vimtest#Quit()
