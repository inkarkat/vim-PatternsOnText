" Test replacement expression.

edit text.txt
1SubstituteSelected/\<\(.\)\(.\)\2\>/\='{' . submatch(2) . ':' . submatch(1) . submatch(0) . '}'/g yn
3SubstituteSelected/foo/\=expand('%:e')/gi yny

call vimtest#SaveOut()
call vimtest#Quit()
