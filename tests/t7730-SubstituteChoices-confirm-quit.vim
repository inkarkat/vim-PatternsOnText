" Test replacing with choices confirm quit.

edit text.txt

let g:IngoLibrary_QueryChoices = ['bar', 'quux', 'quit']
1SubstituteChoices /foo/bar/baz/quux/gc

let g:IngoLibrary_QueryChoices = ['aaa', 'bbb', 'quit']
2,$SubstituteChoices /\<...\>/aaa/bbb/ccc/gc

call vimtest#SaveOut()
call vimtest#Quit()
