" Test reuse of pattern, wildcards, and flags when repeating substitution with whole word flag.

edit text.txt
1SubstituteWildcard foo=FOO ba[rz]=XXX fault!=problem? shout=yell giw
3SubstituteWildcard

call vimtest#SaveOut()
call vimtest#Quit()
