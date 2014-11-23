" Test printing duplicates in the current line.

edit duplicates.txt
echomsg 'start'
9PrintDuplicates \<\w\+\>
echomsg 'end'

call vimtest#Quit()
