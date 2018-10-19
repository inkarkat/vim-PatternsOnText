" Test translating matches with a Funcref that uses the argument.

function! MyFunc( context )
    return submatch(0) . a:context.matchCount
endfunction
edit text.txt
%SubstituteTranslate /\<...\>/MyFunc/g

call vimtest#SaveOut()
call vimtest#Quit()
