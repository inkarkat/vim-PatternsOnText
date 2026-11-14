" Test replacing pair matches with whole WORD flag.

edit text.txt
%SubstituteMultipleExpr /['foo', 'We agree', 'We need']/['FOO', 'Accepted', 'We want']/giW

call vimtest#SaveOut()
call vimtest#Quit()
