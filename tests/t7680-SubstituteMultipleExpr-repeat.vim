" Test reuse of patterns, replacements, and flags when repeating substitution.

edit text.txt
1SubstituteMultipleExpr /['foobar', 'foo', 'FOObar']/['hiho', 'FOO', 'XXXXXX']/g
3SubstituteMultipleExpr

call vimtest#SaveOut()
call vimtest#Quit()
