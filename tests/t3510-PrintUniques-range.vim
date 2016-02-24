" Test printing uniques in the passed range.

set report=999  " Avoid the substitution command being printed in the captured log.
edit duplicates.txt
echomsg 'start'
6,9PrintUniques \<\w\+\>
echomsg 'end'

call vimtest#Quit()
