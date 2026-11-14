" Test replacing pair matches with whole word flag.

edit text.txt
%SubstituteMultipleExpr /['foo', 'bar', 'baz', 'fault!', 'shout']/['FOO', 'XXX', 'XXX', 'problem?', 'yell']/giw

call vimtest#SaveOut()
call vimtest#Quit()
