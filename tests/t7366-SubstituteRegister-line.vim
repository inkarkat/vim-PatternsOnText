" Test replacing register matches with entire line flag.

edit text.txt
let @a = 'foo'
let @b = 'FOO'
call append(0, ['foobar', 'foo', '  foo', 'foo	', '		    foo  	 	'])
%SubstituteRegister a=b gL

call vimtest#SaveOut()
call vimtest#Quit()
