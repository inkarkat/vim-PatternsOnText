" Test replacing with choices confirm no.

edit text.txt

let g:IngoLibrary_QueryChoices = ['bar', 'no', 'no', 'quux']
1SubstituteChoices /foo/bar/baz/quux/gc

let g:IngoLibrary_QueryChoices = ['no', 'bbb', 'no', 'aaa', 'no', 'no', 'aaa']
2,$SubstituteChoices /\<...\>/aaa/bbb/ccc/gc

call vimtest#SaveOut()
call vimtest#Quit()
