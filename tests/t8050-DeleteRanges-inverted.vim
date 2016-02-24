" Test deletion of everything except ranges.

set report=1
edit ranges.txt

/middle/+1,$DeleteRanges! /begin/,/end/-1
1,/middle/-1DeleteRanges! /{/+1,/}/-1

call vimtest#SaveOut()
call vimtest#Quit()
