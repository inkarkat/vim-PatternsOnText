" Test reuse of replacements when repeating substitution.

edit text.txt
1SubstituteMultipleExpr /['foobar', 'foo', 'FOObar']/['hiho', 'FOO', 'XXXXXX']/g
3SubstituteMultipleExpr /['and', 'Foo', 'We']/
2SubstituteMultipleExpr /['She', 'NOT', 'yeah!', 'agreed']
2SubstituteMultipleExpr g

call vimtest#SaveOut()
call vimtest#Quit()
