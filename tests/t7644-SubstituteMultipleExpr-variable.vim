" Test using a variable for pattern and replacements.

edit text.txt
let g:patterns = ['foobar', 'foo', 'FOObar']
let g:repl = ['hiho', 'FOO', 'XXXXXX']
%SubstituteMultipleExpr /g:patterns/g:repl/g

call vimtest#SaveOut()
call vimtest#Quit()
