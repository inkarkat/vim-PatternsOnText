" Test printing duplicates in the current fold.

set report=999  " Avoid the substitution command being printed in the captured log.
edit duplicates.txt
7,9fold
echomsg 'start'
7PrintDuplicates \<\w\+\>
echomsg 'end'

call vimtest#Quit()
