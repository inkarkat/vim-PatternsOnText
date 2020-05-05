" Test reuse of pattern, shift value, and offset when repeating shifting matches.

edit enumeration.txt
call vimtest#StartTap()
call vimtap#Plan(4)

1,4SubstituteRotate /\[\w\+\]/[???]/2/
call vimtap#Is(@", "[five]\n[nine]\n", 'missed last two matches')
7,8SubstituteRotate g
call vimtap#Is(@", "[four]\n[two]\n", 'missed last two matches')

14SubstituteRotate /\[\w\+\]/\="[value-" . (v:val.matchNum + 1) . "]"/+3/g
call vimtap#Is(@", "[eight]\n[nine]\n[ten]\n", 'missed last three matches')
15,16SubstituteRotate
call vimtap#Is(@", "[eight]\n[nine]\n[ten]\n", 'missed last three matches')

call vimtest#SaveOut()
call vimtest#Quit()
