" Test using the test expression to capture additional information.

edit text.txt
%SubstituteTransactional /\<...\>/\=v:val.d[line('.')] . ':' . toupper(v:val.matchText)/gt/let v:val.d[line('.')] = get(v:val.d, line('.'), 0) + 1/
1SubstituteTransactional /\<...\>/\=toupper(v:val.matchText) . '-' . v:val.n/gt/let v:val.n += len(submatch(0))/
2SubstituteTransactional /\<...\>/\='<' . v:val.s . '>'/gt/if submatch(0) =~ '\u\u\u' | let v:val.s .= submatch(0) | endif/

call vimtest#SaveOut()
call vimtest#Quit()
