" Test deletion of ranges.

edit ranges.txt

" Tests that ranges are taken and considered.
/middle/,$DeleteRanges /begin/,/end/

" Tests that the command defaults to the entire buffer.
DeleteRanges /{/+1,/}/-1

call vimtest#SaveOut()
call vimtest#Quit()
