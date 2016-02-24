" Test deleting duplicates in the passed range.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicates.txt
3,$DeleteDuplicates foo
call vimtap#Is(getpos('.'), [0, 9, 1, 0], 'cursor on last line with deletions')

call vimtest#SaveOut()
call vimtest#Quit()
