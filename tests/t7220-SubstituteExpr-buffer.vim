" Test replacing all List expr in the buffer.

edit text.txt
%SubstituteExpr [['foobar', 'hiho'], ['foo', 'FOO'], ['FOObar', 'XXXXXX']] g

call vimtest#SaveOut()
call vimtest#Quit()
