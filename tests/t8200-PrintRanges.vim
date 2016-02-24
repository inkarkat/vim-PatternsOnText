" Test printing of ranges.

edit ranges.txt
setlocal nomodifiable

" Tests that ranges are taken and considered.
echomsg 'start'
/middle/,$PrintRanges /begin/,/end/
echomsg 'end'

call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Ok(! &l:modified, 'buffer not modified')

call vimtest#Quit()
