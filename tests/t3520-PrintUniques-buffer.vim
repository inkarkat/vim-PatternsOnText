" Test printing uniques in the entire buffer.

set report=999  " Avoid the substitution command being printed in the captured log.
edit duplicates.txt
echomsg 'start'
%PrintUniques \<\w\{3,}\>
echomsg 'end'

call vimtest#Quit()
