" Test replacing with choices in a line.

let g:IngoLibrary_QueryChoices = ['BAR', 'QUUX', 'BAR', 'BAZ']
edit text.txt
1
SubstituteChoices /foo/BAR/BAZ/QUUX/g

call vimtest#SaveOut()
call vimtest#Quit()
