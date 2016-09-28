" Test replacing with references with predicate.

edit text.txt
1SubstituteIf/\<\(.\)\(.\)\2\>/{\2:\1\0}/g col('.') % 2
3SubstituteIf/foo/& and &/gi col('.') % 2

call vimtest#SaveOut()
call vimtest#Quit()
