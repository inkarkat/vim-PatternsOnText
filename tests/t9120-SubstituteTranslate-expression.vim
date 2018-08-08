" Test translating matches with an expression.

edit text.txt
%SubstituteTranslate /\<...\>/\='A' . submatch(0) . submatch(0) . 'Z'/g

call vimtest#SaveOut()
call vimtest#Quit()
