" Test command execution over ranges.

edit ranges.txt

" Tests that ranges are taken and considered.
/middle/,$RangeDo /begin/,/end/ execute "normal! I# \<Esc>"

" Tests that the command defaults to the entire buffer.
RangeDo /{/+1,/}/-1 substitute/\S$/(&)/

call vimtest#SaveOut()
call vimtest#Quit()
