" Test repeating substitution with inline search pattern.

edit text.txt
let @/ = '\<NOT\>'
1SubstituteInSearch/\<...\>/[aAeEiIoOuUtT]/X/gf

" Tests that the repeat applies to @/, not the original \<...\>: "She" and "and"
" are kept.
" Tests that the /f flag does not apply to NOT in line 2.
2SubstituteInSearch

" Tests that an updated search pattern is used on "said" and "shouted" in line 2.
" Tests that new flags can be specified.
" Tests that a [count] can be passed: "need" from line 3 is substituted.
let @/ = '\<[ns]\w\+d\>'
2SubstituteInSearch g 2

call vimtest#SaveOut()
call vimtest#Quit()
