" Test replacing pair matches with count.

edit text.txt
1SubstituteMultipleExpr /"o\nx"/"O\nX"/g 2
1SubstituteMultipleExpr /"s"/"S"/g2

call vimtest#SaveOut()
call vimtest#Quit()
