" Test replacing with choices confirm all remaining.

edit text.txt

let g:IngoLibrary_QueryChoices = ['bar', 'quux', 'all remaining as quux']
1SubstituteChoices /foo/bar/baz/quux/gc

let g:IngoLibrary_QueryChoices = ['aaa', 'bbb', 'all remaining as bbb']
2,$SubstituteChoices /\<...\>/aaa/bbb/ccc/gc

call vimtest#SaveOut()
call vimtest#Quit()
