" Test pair with bracket wildcard.

edit text.txt
%SubstituteWildcard fo[ox]=XXX [gh]=? g

call vimtest#SaveOut()
call vimtest#Quit()
