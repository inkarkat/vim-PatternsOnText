" Test using a function for expr.

edit text.txt
function! Expr()
    return [['foobar', 'hiho'], ['foo', 'FOO'], ['FOObar', 'XXXXXX']]
endfunction
%SubstituteExpr Expr() g

call vimtest#SaveOut()
call vimtest#Quit()
