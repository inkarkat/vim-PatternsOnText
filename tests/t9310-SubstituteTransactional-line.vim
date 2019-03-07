" Test replacing matches in a line.

edit text.txt
1
SubstituteTransactional /\<...\>/XXX/g
2SubstituteTransactional /\<...\>/&-&/g
let g:replacements = ['one', 'two', 'three', 'four', 'five']
3SubstituteTransactional /\<...\>/\=remove(g:replacements, 0)/g

call vimtest#SaveOut()
call vimtest#Quit()
