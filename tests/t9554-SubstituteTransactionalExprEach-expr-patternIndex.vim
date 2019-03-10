" Test using patternIndex within replacement expression.

edit text.txt
let g:chars = ['{{', '}}']
%SubstituteTransactionalExprEach /['\ze\<...\>', '\<...\>\zs']/"\\=g:chars[v:val.patternIndex]"/g

call vimtest#SaveOut()
call vimtest#Quit()
