" Test command execution over numeric ranges.
" Tests that lines outside the command's range are ignored.

edit ranges.txt

" Tests that ranges are taken and considered.
/middle/,$RangeDo 14,19 execute "normal! I# \<Esc>"
2,/intermediate/RangeDo 1,4 substitute/\S$/(&)/

call vimtest#SaveOut()
call vimtest#Quit()
