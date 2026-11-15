" Test replacing one pair match in a line.

edit text.txt
1
SubstituteMultipleExpr /['foobar', 'foo', 'FOObar']/['hiho', 'FOO', 'XXXXXX']/

call vimtest#SaveOut()
call vimtest#Quit()
