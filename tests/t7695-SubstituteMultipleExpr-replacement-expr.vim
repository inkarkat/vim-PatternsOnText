" Test replacing pair matches with an expression.

edit text.txt
%SubstituteMultipleExpr /['fo[ox]', '\<and\>', 'Foo']/['\=toupper(submatch(0))', '\=submatch(0) . " " . submatch(0)', 'OOF']/g

call vimtest#SaveOut()
call vimtest#Quit()
