" Test yanking of multiple ranges into register.

edit ranges.txt
setlocal nomodifiable

let @@ = ''
let @a = ''

call vimtest#StartTap()
call vimtap#Plan(2)

4,$YankRanges /begin/,/end/ /{/+1,/}/-1 11 17 /foo/,/bar/a
call vimtap#Is(@a, "\tha\n\thi\n\the\n\tho\nmiddle\nbegin\n    foo\n    zzz\n    bar\nend\n", 'Yanked multiple ranges')

call vimtap#Ok(! &l:modified, 'Buffer not modified')

call vimtest#Quit()
