" Test shifting matches.

edit enumeration.txt
call vimtest#StartTap()
call vimtap#Plan(6)

1,4SubstituteRotate /\[\w\+\]/[???]/1/g
call vimtap#Is(@", '[ten]', 'missed last match')

7SubstituteRotate /\[\w\+\]/[???]/5/g
call vimtap#Is(@", "[two]\n[four]\n[eight]\n", 'missed last three matches')

11,12SubstituteRotate /\[\w\+\]//2/g
call vimtap#Is(@", "[five]\n[ten]\n", 'missed last two matches')

14SubstituteRotate /\[\w\+\]/?/+2/g
call vimtap#Is(@", "[nine]\n[ten]\n", 'missed last two matches')
15SubstituteRotate /\[\w\+\]/?/-1/g
call vimtap#Is(@", '[one]', 'missed first match')

" Test that omitting the shift value returns to rotating.
let @" = ''
16SubstituteRotate /\[\w\+\]/-1/g
call vimtap#Is(@", '', 'nothing missed')

call vimtest#SaveOut()
call vimtest#Quit()
