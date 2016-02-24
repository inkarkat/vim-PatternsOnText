" Test command execution over multiple ranges.

edit ranges.txt

4,$RangeDo /begin/,/end/ /{/+1,/}/-1 11 17 /foo/,/bar/ execute "normal! I# \<Esc>"

call vimtest#SaveOut()
call vimtest#Quit()
