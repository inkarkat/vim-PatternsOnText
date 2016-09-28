" Test reuse of pattern, replacement, flags, and count when repeating substitution.

let g:IngoLibrary_QueryChoices = ['BAR', 'QUUX', 'BAR', 'BAZ']
edit text.txt
1SubstituteChoices /foo/BAR/BAZ/QUUX/g
let g:IngoLibrary_QueryChoices = ['QUUX', 'BAZ']
3SubstituteChoices

call vimtest#SaveOut()
call vimtest#Quit()
