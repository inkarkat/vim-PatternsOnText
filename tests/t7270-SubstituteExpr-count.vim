" Test replacing expr matches with count.

edit text.txt
1SubstituteExpr [["o", "O"], ["x", "X"]] g 2
1SubstituteExpr ["s", "S"] g2

call vimtest#SaveOut()
call vimtest#Quit()
