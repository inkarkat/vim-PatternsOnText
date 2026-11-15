" Test substitution of nine wildcard patterns.

edit text.txt
%SubstituteWildcard foo=FOO ba[rz]=XXX fault!=problem? shout=yell She=He NOT=totally agree=sneeze need=want !=? g

call vimtest#SaveOut()
call vimtest#Quit()
