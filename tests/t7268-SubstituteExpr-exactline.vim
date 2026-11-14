" Test replacing expr matches with exact line flag.

edit text.txt
call append(0, ['foobar', 'foo', '  foo', 'foo	', '		    foo  	 	'])
%SubstituteExpr ['foo', 'FOO'] gE

call vimtest#SaveOut()
call vimtest#Quit()
