" Test printing duplicates in the current line.

edit duplicates.txt
echomsg 'start'
9PrintDuplicates \<\w\+\>
echomsg 'end'

call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Ok(! &l:modified, 'buffer not modified')

call vimtest#Quit()
