" Test printing duplicates of a pattern in the entire buffer.

set report=999  " Avoid the substitution command being printed in the captured log.
edit duplicates.txt
echomsg 'start'
%PrintDuplicates \<\w\+\>
echomsg 'end'

call vimtest#Quit()
