" Test replacing expr matches with literal replacement flag.

edit text.txt
%SubstituteExpr [['fo[ox]', '&&'], ['NOT', '\=v:version'], ['Foo', '\\FOO\\']] gR

call vimtest#SaveOut()
call vimtest#Quit()
