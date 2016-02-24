" Test command execution over marked ranges.
" Tests that lines outside the command's range are ignored.

edit ranges.txt

14normal! ma
19normal! mb
2normal! mc

" Tests that ranges are taken and considered.
/middle/,$RangeDo 'a,'b  execute "normal! I# \<Esc>"
2,/intermediate/RangeDo 'c-1,'c+2  substitute/\S$/(&)/

call vimtest#SaveOut()
call vimtest#Quit()
