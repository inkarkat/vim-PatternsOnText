" Test replacing expr matches with literal flag.

edit text.txt
%SubstituteExpr [['".', '``.'], ['[1-9a-z]', 'X'], ['[1]', '(1)'], ['shout', 'yell']] gP

call vimtest#SaveOut()
call vimtest#Quit()
