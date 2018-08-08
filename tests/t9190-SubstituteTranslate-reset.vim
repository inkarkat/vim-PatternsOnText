" Test clearing memoizations and context object.

edit text.txt
1SubstituteTranslate /\<...\>/\=submatch(0) . v:val.matchCount/g
2,3SubstituteTranslate! /\<...\>/\=v:val.matchCount . submatch(0) /g

call vimtest#SaveOut()
call vimtest#Quit()
