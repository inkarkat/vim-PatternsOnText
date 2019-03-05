" Test replacing all pair matches in the buffer.

edit text.txt
%SubstituteMultipleExpr /['foobar', 'foo', 'FOObar']/['hiho', 'FOO', 'XXXXXX']/g

call vimtest#SaveOut()
call vimtest#Quit()
