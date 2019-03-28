" Test replacing with less available replacements.
" Tests that the last replacement is reused.

edit text.txt
%SubstituteMultipleExpr /['foobar', 'foo', 'fox', 'bar', 'She', 'NOT']/['hiho', 'FOO', 'XXXXXX', 'YYY']/g

call vimtest#SaveOut()
call vimtest#Quit()
