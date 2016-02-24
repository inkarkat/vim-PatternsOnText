" Test replacing one pair match in a line.

edit text.txt
1
SubstituteWildcard foobar=hiho foo=FOO FOObar=XXXXXX

call vimtest#SaveOut()
call vimtest#Quit()
