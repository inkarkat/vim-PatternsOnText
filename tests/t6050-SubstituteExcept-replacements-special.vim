" Test special replacement.

edit text.txt
1SubstituteExcept/\<\(.\).\(.\)\>/\='{'.submatch(1).submatch(2).'}'/
2SubstituteExcept/\<\k*a\k*\>/\=toupper(submatch(0))/
3SubstituteExcept/\s*foo\s*/\='{'.len(submatch(0)).' snipped}'/i

call vimtest#SaveOut()
call vimtest#Quit()
