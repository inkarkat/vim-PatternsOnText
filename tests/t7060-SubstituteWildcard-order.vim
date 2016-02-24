" Test pair ordering when multiple same wildcards.

edit text.txt
%SubstituteWildcard x=X foo=first foo=second y=Y foo=third g

call vimtest#SaveOut()
call vimtest#Quit()
