" Test replacing register matches with whole WORD flag.

let @a = 'foo'
let @b = 'FOO'
let @c = 'We agree'
let @d = 'Accepted'
let @e = 'We need'
let @f = 'We want'
edit text.txt
%SubstituteRegister a=b c=d e=f giW

call vimtest#SaveOut()
call vimtest#Quit()
