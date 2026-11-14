" Test replacing a single pattern, replacement expr in a line.

edit text.txt
1
SubstituteExpr ['foobar', 'hiho']
3SubstituteExpr ['foo', 'FOO']

call vimtest#SaveOut()
call vimtest#Quit()
