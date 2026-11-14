" Test referencing the expr match in the replacement.

edit text.txt
%SubstituteExpr [['fo[ox]', '&&'], ['NOT', '\&&\&'], ['Foo', '\\FOO\\']] g

call vimtest#SaveOut()
call vimtest#Quit()
