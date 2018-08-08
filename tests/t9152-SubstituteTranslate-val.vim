" Test translating matches with an expression that uses v:val.

edit text.txt
%SubstituteTranslate /\<...\>/\=join(add(v:val.l, submatch(0)), '-')/g

call vimtest#SaveOut()
call vimtest#Quit()
