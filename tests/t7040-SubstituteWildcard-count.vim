" Test replacing pair matches with count.

edit text.txt
1SubstituteWildcard o=O g 2
1SubstituteWildcard s=S g2
1,2SubstituteWildcard m=M 2

call vimtest#SaveOut()
call vimtest#Quit()
