" Test replacing all matches in the buffer.

edit text.txt
%SubstituteTransactionalExprEach /['foobar', 'foo', 'FOObar']/['hihohu', 'FOO', 'XXXXXX']/ge

call vimtest#SaveOut()
call vimtest#Quit()
