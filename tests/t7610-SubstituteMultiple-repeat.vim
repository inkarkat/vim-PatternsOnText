" Test reuse of patterns, replacements, and flags when repeating substitution.

edit text.txt
1SubstituteMultiple /foobar/hiho/ /foo/FOO/ /FOObar/XXXXXX/ g
3SubstituteMultiple

call vimtest#SaveOut()
call vimtest#Quit()
