" Test replacing with choices with an abort.

let g:IngoLibrary_QueryChoices = ['BAR', -1]
edit text.txt
1
SubstituteChoices /foo/BAR/BAZ/QUUX/g

call vimtest#SaveOut()
call vimtest#Quit()
