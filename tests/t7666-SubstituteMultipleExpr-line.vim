" Test replacing pair matches with entire line flag.

edit text.txt
call append(0, ['foobar', 'foo', '  foo', 'foo	', '		    foo  	 	'])
%SubstituteMultipleExpr /'foo'/'FOO'/gL

call vimtest#SaveOut()
call vimtest#Quit()
