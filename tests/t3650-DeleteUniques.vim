" Test deleting uniques in the current line.

set report=1
call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicates.txt
9DeleteUniques \<\w\+\>
call vimtap#Is(getpos('.'), [0, 9, 2, 0], 'cursor on last line with deletions')

call vimtest#SaveOut()
call vimtest#Quit()
