" Test replacing register matches with whole word flag.

let @a = 'foo'
let @b = 'FOO'
let @c = 'bar'
let @d = 'XXX'
let @e = 'baz'
let @f = 'XXX'
let @g = 'fault!'
let @h = 'problem?'
let @i = 'shout'
let @j = 'yell'
edit text.txt
%SubstituteRegister a=b c=d e=f g=h i=j giw

call vimtest#SaveOut()
call vimtest#Quit()
