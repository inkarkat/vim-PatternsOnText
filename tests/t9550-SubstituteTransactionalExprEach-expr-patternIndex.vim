" Test using patternIndex within replacement expression.

edit text.txt
%SubstituteTransactionalExprEach /['\%3l\<[Ff]oo\>', '\<...\>']/"\\=v:val.patternIndex == 0 ? v:val.matchText : v:val.matchCount . '-' . toupper(v:val.matchText)"/g

call vimtest#SaveOut()
call vimtest#Quit()
