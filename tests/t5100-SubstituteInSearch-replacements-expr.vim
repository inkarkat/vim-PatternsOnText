" Test substituting with a replacement expression.

edit text.txt
" Tests global replacing of pattern.
let @/ = '([^)]\+)'
1SubstituteInSearch/\<\(.\)..\>/\=submatch(1).toupper(submatch(0))/g

" Tests replacing only the [f]irst occurrence of pattern.
let @/ = '"[^"]\+"'
2SubstituteInSearch/[aeiou]/\='['.submatch(0).']'/gf

call vimtest#SaveOut()
call vimtest#Quit()
