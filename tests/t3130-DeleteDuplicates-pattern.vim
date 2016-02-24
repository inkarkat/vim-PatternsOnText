" Test deleting duplicates in the entire buffer.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicates.txt
%DeleteDuplicates \<\w\+\>\s*
call vimtap#Is(getpos('.'), [0, 10, 1, 0], 'cursor on last line with deletions')

call vimtest#SaveOut()
call vimtest#Quit()
