" Test replacing all matches in the buffer.

edit text.txt
%SubstituteTransactionalExpr /"foobar\nfoo\nFOObar"/"hiho\nFOO\nXXXXXX"/g

call vimtest#SaveOut()
call vimtest#Quit()
