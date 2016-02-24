" Test printing of everything except ranges.

edit ranges.txt

echomsg 'start'
1,/middle/-1PrintRanges! /{/+1,/}/-1
echomsg 'end'
echomsg 'start'
/middle/,$PrintRanges! /begin/,/end/-1
echomsg 'end'

call vimtest#Quit()
