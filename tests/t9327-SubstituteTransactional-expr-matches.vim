" Test the recorded matches.

edit enumeration.txt
1,4SubstituteTransactional /\[\w\+\]/\=v:val.matchText . "/" . v:val.matches[v:val.matchCount]/g

call vimtest#SaveOut()
call vimtest#Quit()
