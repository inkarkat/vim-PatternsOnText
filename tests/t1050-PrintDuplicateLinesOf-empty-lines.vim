" Test printing duplicates including empty lines.

edit duplicateAndEmptyLines.txt
1
echomsg 'start'
1,10PrintDuplicateLinesOf ^spaz$
echomsg 'end'
echomsg 'start'
12,$PrintDuplicateLinesOf ^\%(\cb..\)\?$
echomsg 'end'

call vimtest#Quit()
