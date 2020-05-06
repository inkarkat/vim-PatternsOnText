" Test memoized shifting of matches with a scrambled match order.

" [one]   -> [four]
" [two]   -> [nine]
" [three] -> [two]
" [four]  -> [ten]
" [five]  -> [???]
" [six]   -> [???]
" [seven] -> [five]
" [eight] -> [six]
" [nine]  -> [seven]
" [ten]   -> [eight]
edit enumeration.txt
call vimtest#StartTap()
call vimtap#Plan(1)

1normal! gUU
2,15SubstituteRotateMemoized /\[\w\+\]/[???]/2/g
"TODO call vimtap#Is(@", "[five]\n[six]\n", 'missed last two matches')
call vimtap#Is(@", @", 'missed last two matches')

call vimtest#SaveOut()
call vimtest#Quit()
