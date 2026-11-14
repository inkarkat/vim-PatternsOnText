" Test replacing pair matches with literal flag.

edit text.txt
%SubstituteMultipleExpr /['".', '[1-9a-z]', '[1]', 'shout']/['``.', 'X', '(1)', 'yell']/gP

call vimtest#SaveOut()
call vimtest#Quit()
