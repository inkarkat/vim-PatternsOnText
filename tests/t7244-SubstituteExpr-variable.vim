" Test using a variable for expr.

edit text.txt
let g:expr = [['foobar', 'hiho'], ['foo', 'FOO'], ['FOObar', 'XXXXXX']]
%SubstituteExpr g:expr g

call vimtest#SaveOut()
call vimtest#Quit()
