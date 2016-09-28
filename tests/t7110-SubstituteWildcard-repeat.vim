" Test reuse of pattern, wildcards, and flags when repeating substitution.

edit text.txt
1SubstituteWildcard foobar=hiho foo=FOO FOObar=XXXXXX g
3SubstituteWildcard

call vimtest#SaveOut()
call vimtest#Quit()
