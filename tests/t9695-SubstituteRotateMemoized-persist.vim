" Test memoized rotation in multiple calls with persisted memoization.

edit enumeration.txt
1,4SubstituteRotateMemoized! /\[\w\+\]/1/g
7,8SubstituteRotateMemoized /\[\w\+\]/1/g

11,12SubstituteRotateMemoized! /\[\w\+\]/1/g
14SubstituteRotateMemoized /\[\w\+\]/+5/g
15SubstituteRotateMemoized /\[\w\+\]/-1/g
16SubstituteRotateMemoized /\[\w\+\]/-2/g

call vimtest#SaveOut()
call vimtest#Quit()
