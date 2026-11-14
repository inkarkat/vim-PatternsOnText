" Test replacing all pattern-reg=replacement-reg in the buffer.

let @a = 'foobar'
let @b = 'hiho'
let @c = 'foo'
let @d = 'FOO'
let @e = 'FOObar'
let @f = 'XXXXXX'
edit text.txt
%SubstituteRegister a=b c=d e=f g

call vimtest#SaveOut()
call vimtest#Quit()
