" Test replacing pair matches with whole WORD flag.

edit text.txt
%SubstituteWildcard foo=FOO We\ agree=Accepted We\ need=We\ want giW

call vimtest#SaveOut()
call vimtest#Quit()
