" Test deletion of marked ranges.
" Tests that lines outside the command's range are ignored.

edit ranges.txt

14normal! ma
19normal! mb
2normal! mc

" Tests that ranges are taken and considered.
/middle/,$DeleteRanges 'a,'b
2,/intermediate/DeleteRanges 'c-1,'c+2

call vimtest#SaveOut()
call vimtest#Quit()
