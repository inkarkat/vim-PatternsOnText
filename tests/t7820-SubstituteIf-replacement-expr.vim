" Test replacement expression with predicate.

edit text.txt
1SubstituteIf/\<\(.\)\(.\)\2\>/\='{' . submatch(2) . ':' . submatch(1) . submatch(0) . '}'/g col('.') % 2
3SubstituteIf/foo/\=expand('%:e')/gi col('.') % 2

call vimtest#SaveOut()
call vimtest#Quit()
