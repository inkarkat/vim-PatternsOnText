" Test access of arbitrary recorded matches.

edit enumeration.txt
1,4SubstituteTransactional /\[\w\+\]/\=v:val.matches[v:val.matchNum - v:val.matchCount + 1]/g

7,12SubstituteTransactional /\[\w\+\]/\=v:val.matchText . "/" . v:val.matches[v:val.matchNum]/g

call vimtest#SaveOut()
call vimtest#Quit()
