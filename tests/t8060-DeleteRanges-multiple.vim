" Test deletion of multiple ranges into register.

edit ranges.txt

let @@ = ''
let @a = ''

call vimtest#StartTap()
call vimtap#Plan(1)

4,$DeleteRanges /begin/,/end/ /{/+1,/}/-1 11 17 /foo/,/bar/ a
call vimtap#Is(@a, "\tha\n\thi\n\the\n\tho\nmiddle\nbegin\n    foo\n    zzz\n    bar\nend\n", 'Deleted multiple ranges')

call vimtest#SaveOut()
call vimtest#Quit()
