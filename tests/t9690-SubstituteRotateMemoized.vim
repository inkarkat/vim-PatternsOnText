" Test memoized rotating of matches.

edit enumeration.txt
%SubstituteRotateMemoized /\[\w\+\]/1/g

call vimtest#SaveOut()
call vimtest#Quit()
