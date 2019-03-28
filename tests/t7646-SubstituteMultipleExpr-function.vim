" Test using a function for pattern and replacements.

edit text.txt
function! Patterns()
    return ['foobar', 'foo', 'FOObar']
endfunction
function! Replacements()
    return ['hiho', 'FOO', 'XXXXXX']
endfunction
%SubstituteMultipleExpr /Patterns()/Replacements()/g

call vimtest#SaveOut()
call vimtest#Quit()
