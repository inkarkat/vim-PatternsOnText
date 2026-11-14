" Test replacing a single pattern-reg=replacement-reg in a line.

let @a = 'foobar'
let @b = 'hiho'
let @c = 'foo'
let @d = 'FOO'
edit text.txt
1
SubstituteRegister a=b
3SubstituteRegister c=d

call vimtest#SaveOut()
call vimtest#Quit()
