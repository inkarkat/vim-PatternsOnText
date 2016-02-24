" Test printing of everything except multiple ranges.

edit ranges.txt

" Tests that ranges are taken and considered.
echomsg 'start'
4,$PrintRanges! /begin/,/end/ /{/+1,/}/-1 11 17 /foo/,/bar/
echomsg 'end'

call vimtest#Quit()
