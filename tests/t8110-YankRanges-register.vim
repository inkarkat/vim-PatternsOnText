" Test yanking of ranges into register.

edit ranges.txt
setlocal nomodifiable

let @@ = ''
let @a = ''

call vimtest#StartTap()
call vimtap#Plan(3)

/middle/,$YankRanges /begin/,/end/ a
call vimtap#Is(@a, "begin\n    foo\n    zzz\n    bar\nend\n", 'Yanked range /begin/,/end/')

" Tests that the command defaults to the entire buffer.
YankRanges /{/+1,/}/-1
call vimtap#Is(@@, "\tha\n\thi\n\the\n\tho\n", 'Yanked ranges inside {}')

call vimtap#Ok(! &l:modified, 'Buffer not modified')

call vimtest#Quit()
