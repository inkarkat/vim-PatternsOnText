" Test memoized shifting of matches, each independent.

edit enumeration.txt
call vimtest#StartTap()
call vimtap#Plan(5)

1,4SubstituteRotateMemoized! /\[\w\+\]/[???]/1/g
call vimtap#Is(@", '[ten]', 'missed last match')

7SubstituteRotateMemoized! /\[\w\+\]/[???]/5/g
call vimtap#Is(@", "[two]\n[four]\n[eight]\n", 'missed last three matches')

11,12SubstituteRotateMemoized! /\[\w\+\]//2/g
call vimtap#Is(@", "[seven]\n[nine]\n[ten]\n", 'missed last three matches')

14SubstituteRotateMemoized! /\[\w\+\]/?/+2/g
call vimtap#Is(@", "[nine]\n[ten]\n", 'missed last two matches')
15SubstituteRotateMemoized! /\[\w\+\]/?/-1/g
call vimtap#Is(@", '[one]', 'missed first match')

call vimtest#SaveOut()
call vimtest#Quit()
