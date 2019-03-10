" Test replacing all matches in the buffer.

edit text.txt
%SubstituteTransactionalExprEach /"foobar\nfoo"/"hihohuppala\nFOOX"/g

call vimtest#SaveOut()
call vimtest#Quit()
