" Test replacing with predicate that uses v:val.

edit text.txt
%SubstituteExecute /foo/g let l:col = col('.') | let l:seenCol = has_key(v:val.d, l:col) | let v:val.d[l:col] = 1 | if ! l:seenCol | return "BAR" | endif

call vimtest#SaveOut()
call vimtest#Quit()
