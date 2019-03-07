" Test using the test expression to capture additional information.

edit text.txt
%SubstituteTransactionalExpr /['\<...\>', '\[1\]']/"\\=v:val.d[line('.')] . ':' . toupper(v:val.matchText)"/gt/let v:val.d[line('.')] = get(v:val.d, line('.'), 0) + 1/

call vimtest#SaveOut()
call vimtest#Quit()
