" Test translating matches with an expression that uses v:val.

edit text.txt
%SubstituteTranslate /\<...\>/\=submatch(0) . v:val.matchCount/g

call vimtest#SaveOut()
call vimtest#Quit()
