" Test replacing List expr in a line.

edit text.txt
1
SubstituteExpr [['foobar', 'hiho'], ['foo', 'FOO'], ['FOObar', 'XXXXXX']]

call vimtest#SaveOut()
call vimtest#Quit()
