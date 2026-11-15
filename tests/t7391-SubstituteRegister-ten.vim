" Test replacing ten pattern-reg=replacement-reg.
" Tests that the implementation avoids E872: (NFA regexp) Too many '('

let @a = 'foo'
let @b = 'FOO'
let @c = 'ba[rz]'
let @d = 'XXX'
let @e = 'fault!'
let @f = 'problem?'
let @g = 'shout'
let @h = 'yell'
let @i = 'She'
let @j = 'He'
let @k = 'NOT'
let @l = 'totally'
let @m = 'agree'
let @n = 'sneeze'
let @o = 'need'
let @p = 'want'
let @q = '!'
let @r = '?'
let @s = 'We'
let @t = 'All'
edit text.txt
%SubstituteRegister a=b c=d e=f g=h i=j k=l m=n o=p q=r s=t g

call vimtest#SaveOut()
call vimtest#Quit()
