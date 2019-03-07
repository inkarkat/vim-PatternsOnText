" Test stopping short of replacing all matches.

call vimtest#StartTap()
call vimtap#Plan(1)

edit text.txt
let g:replacements = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight']
%SubstituteTransactional /\<...\>/\=v:val.matchCount > len(g:replacements) ? v:val.matchText : g:replacements[v:val.matchCount - 1]/g
call vimtap#Is(getpos('.')[1:2], [2, 1], 'cursor positioned on the line of the last actual substitution')

call vimtest#SaveOut()
call vimtest#Quit()
