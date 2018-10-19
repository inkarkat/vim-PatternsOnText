" Test replacing with choices confirm last.

edit text.txt

let g:IngoLibrary_QueryChoices = ['bar', 'quux', 'last as quux']
1SubstituteChoices /foo/bar/baz/quux/gc

let g:IngoLibrary_QueryChoices = ['aaa', 'bbb', 'last as bbb']
2,$SubstituteChoices /\<...\>/aaa/bbb/ccc/gc

call vimtest#SaveOut()
call vimtest#Quit()
