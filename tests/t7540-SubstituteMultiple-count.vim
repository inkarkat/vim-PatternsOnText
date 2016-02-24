" Test replacing pair matches with count.

edit text.txt
1SubstituteMultiple /o/O/ g 2
1SubstituteMultiple /s/S/ g2
1,2SubstituteMultiple /m/M/ 2

call vimtest#SaveOut()
call vimtest#Quit()
