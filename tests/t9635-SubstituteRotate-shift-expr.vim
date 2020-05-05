" Test shifting matches with expression shift value.

edit enumeration.txt
1,4SubstituteRotate /\[\w\+\]/\="[undefined]"/1/g

7SubstituteRotate /\[\w\+\]/\=add(v:val.l, "[new-" . (len(v:val.l) + 1) . "]")[-1]/4/g

11,12SubstituteRotate /\[\w\+\]/\=[]/2/g

14SubstituteRotate /\[\w\+\]/\="[value-" . (v:val.matchNum + 1) . "]"/+2/g
15SubstituteRotate /\[\w\+\]/\="[value-" . (v:val.matchNum + 1) . "]"/-1/g

" Test that omitting the shift value returns to rotating.
16SubstituteRotate /\[\w\+\]/-1/g

call vimtest#SaveOut()
call vimtest#Quit()
