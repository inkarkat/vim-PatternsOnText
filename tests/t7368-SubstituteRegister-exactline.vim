" Test replacing register matches with exact line flag.

let @a = 'foo'
let @b = 'FOO'
edit text.txt
call append(0, ['foobar', 'foo', '  foo', 'foo	', '		    foo  	 	'])
%SubstituteRegister a=b gE

call vimtest#SaveOut()
call vimtest#Quit()
