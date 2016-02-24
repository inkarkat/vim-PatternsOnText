" Test repeating substitution.

edit text.txt
let @/ = '\<...\>'
1SubstituteInSearch/o/X/gi

" Tests that the /i flag does not apply to NOT in line 2.
" Tests that the /g flag does not apply in line 3.
" Tests that a [count] can be passed.
2SubstituteInSearch 2

" Tests that an updated search pattern is used on "shouted" in line 2.
" Tests that new flags can be specified.
" Tests that the previous [count] is not used; line 3 is not modified.
let @/ = '\<s\w\+d\>'
2SubstituteInSearch g

call vimtest#SaveOut()
call vimtest#Quit()
