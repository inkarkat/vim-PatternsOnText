" Test replacing expr matches with an expression.

edit text.txt
%SubstituteExpr [['fo[ox]', '\=toupper(submatch(0))'], ['\<and\>', '\=submatch(0) . " " . submatch(0)'], ['Foo', 'OOF']] g

call vimtest#SaveOut()
call vimtest#Quit()
