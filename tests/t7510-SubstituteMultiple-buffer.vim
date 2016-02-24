" Test replacing all pair matches in the buffer.

edit text.txt
%SubstituteMultiple /fo\+ba\+r/hiho/ #foo#FOO# @FOObar@XXXXXX@ g

call vimtest#SaveOut()
call vimtest#Quit()
