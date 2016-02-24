" Test pair with question mark wildcard.

edit text.txt
%SubstituteWildcard fo?=XXX g

call vimtest#SaveOut()
call vimtest#Quit()
