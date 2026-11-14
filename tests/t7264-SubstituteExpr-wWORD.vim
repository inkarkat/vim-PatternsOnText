" Test replacing expr matches with whole WORD flag.

edit text.txt
%SubstituteExpr [['foo', 'FOO'], ['We agree', 'Accepted'], ['We need', 'We want']] giW

call vimtest#SaveOut()
call vimtest#Quit()
