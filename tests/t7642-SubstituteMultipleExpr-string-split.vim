" Test that a multiline string is split for pattern and replacements.

edit text.txt
%SubstituteMultipleExpr /"foobar\nfoo\nFOObar"/"hiho\nFOO\nXXXXXX"/g

call vimtest#SaveOut()
call vimtest#Quit()
