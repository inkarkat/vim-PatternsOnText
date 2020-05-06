" Test memoized shifting of matches with a scrambled match order.

" [one]   -> [???]
" [two]   -> [eight]
" [three] -> [???]
" [four]  -> [four]
" [five]  -> [seven]
" [six]   -> [eight]
" [seven] -> [nine]
" [eight] -> [ten]
" [nine]  -> [two]
" [ten]   -> [four]
edit enumeration.txt
call vimtest#StartTap()
call vimtap#Plan(1)

1normal! gUU
2,15SubstituteRotateMemoized /\[\w\+\]/[???]/-2/g
call vimtap#Is(@", "[five]\n[six]\n", 'missed first two matches')

call vimtest#SaveOut()
call vimtest#Quit()
