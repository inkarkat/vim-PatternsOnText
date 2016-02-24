" Test deletion of numeric ranges.
" Tests that lines outside the command's range are ignored.

edit ranges.txt

" Tests that ranges are taken and considered.
/middle/,$DeleteRanges 14,19
2,/intermediate/DeleteRanges 1,4

call vimtest#SaveOut()
call vimtest#Quit()
