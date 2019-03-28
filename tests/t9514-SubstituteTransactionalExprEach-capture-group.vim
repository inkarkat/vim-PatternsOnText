" Test using allowed capture groups.

edit text.txt
%SubstituteTransactionalExprEach /['bar', 'f\(o\+\)']/['XXX', 'FOO']/g

call vimtest#SaveOut()
call vimtest#Quit()
