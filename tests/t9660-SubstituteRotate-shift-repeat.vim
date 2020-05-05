" Test reuse of pattern, shift value, and offset when repeating shifting matches.

edit enumeration.txt
1,4SubstituteRotate /\[\w\+\]/[???]/2/
7,8SubstituteRotate g

14SubstituteRotate /\[\w\+\]/\="[value-" . (v:val.matchNum + 1) . "]"/+3/g
15,16SubstituteRotate

call vimtest#SaveOut()
call vimtest#Quit()
