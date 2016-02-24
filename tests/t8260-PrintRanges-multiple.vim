" Test printing of multiple ranges.

edit ranges.txt
setlocal nomodifiable

" Tests that ranges are taken and considered.
echomsg 'start'
4,$PrintRanges /begin/,/end/ /{/+1,/}/-1 11 17 /foo/,/bar/
echomsg 'end'

call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Ok(! &l:modified, 'Buffer not modified')

call vimtest#Quit()
