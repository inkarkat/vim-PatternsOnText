" Test using patternIndex within replacement expression.

edit text.txt
%SubstituteTransactionalExprEach /['\<...\>!\@=', '\<[Ff]oo\>', '\<...\>']/"\\=v:val.matchText . '<' . v:val.patternIndex . '>'"/g

call vimtest#SaveOut()
call vimtest#Quit()
