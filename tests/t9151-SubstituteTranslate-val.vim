" Test translating matches with an expression that uses v:val.

edit text.txt
%SubstituteTranslate /\<...\>/\=submatch(0) . (v:val.replacementCount + 1)/g

call vimtest#SaveOut()
call vimtest#Quit()
