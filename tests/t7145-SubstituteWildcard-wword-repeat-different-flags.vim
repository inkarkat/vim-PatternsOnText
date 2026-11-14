" Test reuse of pattern, wildcards, but new flags when repeating substitution with whole word flag.

edit text.txt
1SubstituteWildcard foo=FOO ba[rz]=XXX fault!=problem? shout=yell giw
2SubstituteWildcard g

call vimtest#SaveOut()
call vimtest#Quit()
