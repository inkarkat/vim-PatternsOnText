" Test printing uniques in the current line.

edit duplicates.txt
echomsg 'start'
9PrintUniques \<\w\+\>
echomsg 'end'

call vimtest#Quit()
