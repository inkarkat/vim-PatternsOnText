" Test pair with star wildcard.

edit text.txt
%SubstituteWildcard lo*y=nice agr*ed=laughed

call vimtest#SaveOut()
call vimtest#Quit()
