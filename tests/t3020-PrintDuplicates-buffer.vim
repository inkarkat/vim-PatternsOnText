" Test printing duplicates in the entire buffer.

set report=999  " Avoid the substitution command being printed in the captured log.
edit duplicates.txt
echomsg 'start'
%PrintDuplicates foo
echomsg 'end'

call vimtest#Quit()
