" Test referencing the match in the replacement.

edit text.txt
%SubstituteMultipleExpr /['fo[ox]', 'NOT', 'Foo']/['&&', '\&&\&', '\\FOO\\']/g

call vimtest#SaveOut()
call vimtest#Quit()
