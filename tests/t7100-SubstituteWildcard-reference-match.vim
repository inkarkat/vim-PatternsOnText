" Test referencing the match in the replacement.

if exists('+shellslash')
    set shellslash  " For reproducible results also on Windows.
endif

edit text.txt
1SubstituteWildcard fo[ox]=&& g
2SubstituteWildcard NOT=\&&\&
3SubstituteWildcard foo=\\FOO\\

call vimtest#SaveOut()
call vimtest#Quit()
