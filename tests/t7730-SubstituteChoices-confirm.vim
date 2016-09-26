" Test replacing with choices confirm options.

edit text.txt

let g:IngoLibrary_QueryChoices = ['bar', 'quux', 'quit']
1SubstituteChoices /foo/bar/baz/quux/gc

let g:IngoLibrary_QueryChoices = ['aaa', 'bbb', 'all remaining as bbb']
2SubstituteChoices /\<...\>/aaa/bbb/ccc/gc

call vimtest#SaveOut()
call vimtest#Quit()
