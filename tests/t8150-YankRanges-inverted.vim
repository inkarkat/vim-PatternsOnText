" Test yanking of everything except ranges.

edit ranges.txt
setlocal nomodifiable

let @@ = ''

call vimtest#StartTap()
call vimtap#Plan(2)
YankRanges! /begin/,/end/
call vimtap#Is(@@, "middle\nEOF\n", 'Yanked except range /begin/,/end/')
call vimtap#Ok(! &l:modified, 'Buffer not modified')

call vimtest#Quit()
