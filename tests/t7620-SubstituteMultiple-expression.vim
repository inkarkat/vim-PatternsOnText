" Test replacing pair matches with an expression.

edit text.txt
%SubstituteMultiple /fo[ox]/\=toupper(submatch(0))/ /\<and\>/\=submatch(0) . ' ' . submatch(0)/ g

call vimtest#SaveOut()
call vimtest#Quit()
