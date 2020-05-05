" Test memoized shifting of matches.

edit enumeration.txt
call vimtest#StartTap()
call vimtap#Plan(1)
%SubstituteRotateMemoized /\[\w\+\]/[???]/-2/g
call vimtap#Is(@", "[one]\n[two]\n", 'missed first two matches')

call vimtest#SaveOut()
call vimtest#Quit()
