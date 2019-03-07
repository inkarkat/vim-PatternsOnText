" Test replacing all matches in the buffer.

edit text.txt
%SubstituteTransactionalExpr /['foobar', 'foo', 'FOObar']/['hiho', 'FOO', 'XXXXXX']/g

call vimtest#SaveOut()
call vimtest#Quit()
