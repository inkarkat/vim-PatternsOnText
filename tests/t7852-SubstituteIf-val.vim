" Test replacing with predicate that uses v:val.

function! Predicate( context )
    let l:col = col('.')
    let l:seenCol = has_key(a:context.d, l:col)
    let a:context.d[l:col] = 1
    return ! l:seenCol
endfunction
edit text.txt
%SubstituteIf /foo/BAR/g Predicate(v:val)

call vimtest#SaveOut()
call vimtest#Quit()
