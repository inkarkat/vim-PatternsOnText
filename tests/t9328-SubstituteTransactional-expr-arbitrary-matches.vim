" Test access of arbitrary recorded matches.

edit enumeration.txt
%SubstituteTransactional /\[\w\+\]/\=v:val.matches[v:val.matchNum - v:val.matchCount + 1]/g

call vimtest#SaveOut()
call vimtest#Quit()
