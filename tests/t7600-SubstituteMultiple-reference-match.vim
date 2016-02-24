" Test referencing the match in the replacement.

edit text.txt
1SubstituteMultiple /fo[ox]/&&/ g
2SubstituteMultiple /NOT/\\&&\&/
3SubstituteMultiple /foo/\\\\FOO\\\\/

call vimtest#SaveOut()
call vimtest#Quit()
