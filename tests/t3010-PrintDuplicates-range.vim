" Test printing duplicates in the passed range.

set report=999  " Avoid the substitution command being printed in the captured log.
edit duplicates.txt
echomsg 'start'
6,9PrintDuplicates foo
echomsg 'end'

call vimtest#Quit()
