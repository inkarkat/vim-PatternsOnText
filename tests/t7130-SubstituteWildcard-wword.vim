" Test replacing pair matches with whole word flag.

edit text.txt
%SubstituteWildcard foo=FOO ba[rz]=XXX fault!=problem? shout=yell giw

call vimtest#SaveOut()
call vimtest#Quit()
