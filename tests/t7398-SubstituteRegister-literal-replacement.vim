" Test replacing register matches with literal replacement flag.

let @a = 'fo[ox]'
let @b = '&&'
let @c = 'NOT'
let @d = '\=v:version'
let @e = 'Foo'
let @f = '\\FOO\\'
edit text.txt
%SubstituteRegister a=b c=d e=f gR

call vimtest#SaveOut()
call vimtest#Quit()
