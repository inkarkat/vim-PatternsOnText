" Test replacing expr matches with whole word flag.

edit text.txt
%SubstituteExpr [['foo', 'FOO'], ['bar', 'XXX'], ['baz', 'XXX'], ['fault!', 'problem?'], ['shout', 'yell']] giw

call vimtest#SaveOut()
call vimtest#Quit()
