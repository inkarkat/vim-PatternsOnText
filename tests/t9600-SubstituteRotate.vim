" Test rotating matches.

edit enumeration.txt
1,4SubstituteRotate /\[\w\+\]/1/g

7SubstituteRotate /\[\w\+\]/4/g

14SubstituteRotate /\[\w\+\]/+2/g
15SubstituteRotate /\[\w\+\]/-1/g
16SubstituteRotate /\[\w\+\]/-2/g

call vimtest#SaveOut()
call vimtest#Quit()
