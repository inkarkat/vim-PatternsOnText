" Test replacing all matches in the buffer.

edit text.txt
" Note: Need to add /e flag to suppress error about /FOObar/ not found.
%SubstituteTransactionalExprEach /['foobar', 'foo', 'FOObar']/['hihohu', 'FOO', 'XXXXXX']/ge

call vimtest#SaveOut()
call vimtest#Quit()
