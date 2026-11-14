" Test replacing pair matches with literal replacement flag.

edit text.txt
%SubstituteMultipleExpr /['fo[ox]', 'NOT', 'Foo']/['&&', '\=v:version', '\\FOO\\']/gR

call vimtest#SaveOut()
call vimtest#Quit()
