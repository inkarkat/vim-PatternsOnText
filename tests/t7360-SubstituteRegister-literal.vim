" Test replacing register matches with literal flag.

let @a = '".'
let @b =  '``.'
let @c = '[1-9a-z]'
let @d = 'X'
let @e = '[1]'
let @f = '(1)'
let @g = 'shout'
let @h = 'yell'
edit text.txt
%SubstituteRegister a=b c=d e=f g=h gP

call vimtest#SaveOut()
call vimtest#Quit()
