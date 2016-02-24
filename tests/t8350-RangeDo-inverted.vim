" Test command execution over everything except ranges.

edit ranges.txt

/middle/+1,$RangeDo! /begin/,/end/-1 execute "normal! I# \<Esc>"
1,/middle/-1RangeDo! /{/+1,/}/-1 substitute/\S$/(&)/

call vimtest#SaveOut()
call vimtest#Quit()
