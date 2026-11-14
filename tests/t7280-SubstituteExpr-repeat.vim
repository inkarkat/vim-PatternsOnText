" Test reuse of patterns, replacements, and flags when repeating expr substitution.

edit text.txt
1SubstituteExpr [['foobar', 'hiho'], ['foo', 'FOO'], ['FOObar', 'XXXXXX']] g
3SubstituteExpr

call vimtest#SaveOut()
call vimtest#Quit()
