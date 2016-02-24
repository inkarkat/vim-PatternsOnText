" Test substituting with the same replacement as before.

edit text.txt
let @/ = '\<...\>'
1SubstituteInSearch/o/X/g

" Tests that the last replacement from :SubstituteInSearch is taken and that a
" :substitute does not override it.
3substitute//moo/g

3SubstituteInSearch/o/~/g

call vimtest#SaveOut()
call vimtest#Quit()
