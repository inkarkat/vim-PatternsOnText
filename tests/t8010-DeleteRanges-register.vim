" Test deletion of ranges into register.

edit ranges.txt

let @@ = ''
let @a = ''

call vimtest#StartTap()
call vimtap#Plan(2)

/middle/,$DeleteRanges /begin/,/end/ a
call vimtap#Is(@a, "begin\n    foo\n    zzz\n    bar\nend\n", 'Deleted range /begin/,/end/')

" Tests that the command defaults to the entire buffer.
DeleteRanges /{/+1,/}/-1
call vimtap#Is(@@, "\tha\n\thi\n\the\n\tho\n", 'Deleted ranges inside {}')

call vimtest#SaveOut()
call vimtest#Quit()
