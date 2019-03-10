" Test replacing with less available replacements.
" Tests that the last replacement is reused.

edit text.txt
%SubstituteTransactionalExprEach /['foobar', 'foo', 'fox', 'bar', 'She', 'NOT']/['hiho', 'FOO', 'XXXXXX', 'YYY']/g

call vimtest#SaveOut()
call vimtest#Quit()
