" Test deleting all duplicates in the entire buffer.

call vimtest#StartTap()
call vimtap#Plan(1)

edit duplicates.txt
%DeleteAllDuplicates\s*\<\w\+\>
call vimtap#Is(getpos('.'), [0, 10, 2, 0], 'cursor on last line with deletions')

call vimtest#SaveOut()
call vimtest#Quit()
